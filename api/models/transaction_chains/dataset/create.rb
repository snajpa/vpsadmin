module TransactionChains
  class Dataset::Create < ::TransactionChain
    label 'Create'

    def link_chain(
      pool,
      dataset_in_pool,
      path,
      automount,
      properties,
      user = nil,
      label = nil,
      userns_map = nil
    )
      lock(dataset_in_pool) if dataset_in_pool
      concerns(
        :affect,
        [dataset_in_pool.dataset.class.name, dataset_in_pool.dataset_id]
      ) if dataset_in_pool

      ret = []
      @pool = pool
      @dataset_in_pool = dataset_in_pool
      @parent = dataset_in_pool && dataset_in_pool.dataset
      @parent_properties = {}
      @automount = dataset_in_pool && automount

      find_parent_mounts(dataset_in_pool) if @automount

      path[0..-2].each do |part|
        ret << create_dataset(part)
      end

      ret << create_dataset(path.last, properties, label, userns_map)

      use_prop = nil

      if properties[:refquota] && pool.refquota_check
        use_prop = :refquota

      elsif properties[:quota] && ret.last.dataset.parent_id.nil?
        use_prop = :quota
      end

      if use_prop
        use = ret.last.allocate_resource!(
          :diskspace,
          properties[use_prop],
          user: user || dataset_in_pool.dataset.user
        )

        append(Transactions::Utils::NoOp, args: pool.node_id) do
          create(use)
        end
      end

      generate_mounts if @automount

      ret
    end

    def create_dataset(part, properties = {}, label = nil, userns_map = nil)
      if part.new_record?
        part.parent ||= @parent
        part.save!

      else
        part.expiration_date = nil
        part.save!
      end

      @parent = part

      dip = ::DatasetInPool.create!(
        dataset: part,
        pool: @pool,
        label: label,
        user_namespace_map: userns_map,
        confirmed: ::DatasetInPool.confirmed(:confirm_create)
      )

      lock(dip)

      @parent_properties = tmp = ::DatasetProperty.inherit_properties!(dip, @parent_properties, properties)

      append(Transactions::Storage::CreateDataset, args: [dip, properties]) do
        create(part)
        create(dip)
        tmp.each_value { |p| create(p) }
      end

      dip.call_class_hooks_for(:create, self, args: [dip])

      create_mounts(dip) if @automount

      dip
    end

    def find_parent_mounts(dataset_in_pool)
      @vps_mounts = {}
      @new_mounts = {}

      # Find all mounts of parent dataset
      parent_dip = dataset_in_pool.dataset.dataset_in_pools.where(pool: dataset_in_pool.pool).take!

      parent_dip.mounts.includes(:vps).joins(:vps).where(
        vpses: {object_state: [
          ::Vps.object_states[:active],
          ::Vps.object_states[:suspended]
        ]}
      ).each do |mnt|
        @vps_mounts[mnt.vps] ||= []
        @vps_mounts[mnt.vps] << mnt
      end

      # If no parent is mounted anywhere and the dataset is a subdataset
      # of a VPS, it is mounted to the VPS root.
      if @vps_mounts.empty?
        vps = ::Vps.find_by(dataset_in_pool: dataset_in_pool.dataset.root.primary_dataset_in_pool!)

        if vps
          @vps_mounts[vps] = [::Mount.new(
            vps: vps,
            dst: "/#{dataset_in_pool.dataset.full_name.split('/')[1..-1].join('/')}",
            mount_opts: '--bind',
            umount_opts: '-f',
            mount_type: 'bind',
            mode: 'rw',
            user_editable: true,
            dataset_in_pool: dataset_in_pool
          )]
        end
      end
    end

    def create_mounts(dip)
      @vps_mounts.each do |vps, mounts|
        mounts.each do |mnt|
          attrs = mnt.attributes
          attrs.delete('id')

          new_mnt = ::Mount.new(attrs)
          new_mnt.assign_attributes(
            vps: vps,
            dataset_in_pool: dip,
            confirmed: ::Mount.confirmed(:confirm_create)
          )

          new_mnt.dst = File.join(new_mnt.dst, '/', dip.dataset.name)
          mnt.dst = new_mnt.dst
          new_mnt.save!

          @new_mounts[vps] ||= []
          @new_mounts[vps] << new_mnt
        end
      end
    end

    def generate_mounts
      @new_mounts.each do |vps, mounts|
        use_chain(Vps::Mounts, args: vps)
        use_chain(Vps::Mount, args: [vps, mounts]) if vps.running?

        append(Transactions::Utils::NoOp, args: vps.node_id) do
          mounts.each { |m| create(m) }
        end
      end
    end
  end
end
