module TransactionChains
  class Dataset::Create < ::TransactionChain
    label 'Create dataset'

    def link_chain(dataset_in_pool, path, mountpoints = [])
      lock(dataset_in_pool)

      parent = dataset_in_pool.dataset

      i = 0

      path.each do |part|
        if part.new_record?
          part.parent ||= parent
          part.save!
          parent = part

        else
          parent = part
          next
        end

        dip = ::DatasetInPool.create(
            dataset: part,
            pool: dataset_in_pool.pool,
            mountpoint: mountpoints[i],
            confirmed: ::DatasetInPool.confirmed(:confirm_create)
        )

        lock(dip)

        append(Transactions::Storage::CreateDataset, args: dip) do
          create(part)
          create(dip)
        end

        if mountpoints[i]
          use_chain(TransactionChains::Dataset::Set, dip, {mountpoint: mountpoints[i]})
        end

        i += 1
      end

      parent
    end
  end
end
