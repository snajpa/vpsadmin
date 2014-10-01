# General transaction. Should be inherited for concrete use. This is just basic
# inheritance, no ActiveRecord inheritance necessary.
# Subclasses must implement method #prepare.
# Subclass can also define following attributes:
# [t_name]    a name for this transaction for future referencing, symbol
# [t_type]    numeric code as recognized in vpsAdmin
class Transaction < ActiveRecord::Base
  self.primary_key = 't_id'

  belongs_to :transaction_chain
  references :user, foreign_key: :t_m_id
  references :node, foreign_key: :t_server
  references :vps, foreignKey: :t_vps
  has_many :transaction_confirmations

  enum t_done: %i(waiting done staged)

  before_save :set_init_values

  class << self
    def t_name(name=nil)
      if name
        @name = name
      else
        @name
      end
    end

    def t_type(t=nil)
      if t
        @t_type = t
      else
        @t_type
      end
    end
  end

  # Called from TransactionChain when appending transaction.
  # Transaction is to be in +chain+, +dep+ is the id of the previous transaction
  # in the chain.
  # When given a block, it is called in the context of Confirmable.
  def self.fire_chained(chain, dep, *args, &block)
    t = new

    t.transaction_chain = chain
    t.t_depends_on = dep
    t.t_type = t.class.t_type if t.class.t_type

    if block
      t.t_done = :staged
      t.save!

      c = Confirmable.new(t)
      c.instance_exec(t, &block)
    end

    t.t_param = (t.params(*args) || {}).to_json
    t.t_done = :waiting

    t.save!
    t.t_id
  end

  # Set default values for start time, success, done and user id.
  def set_init_values
    self.t_time = Time.new.to_i
    self.t_success = 0
    self.t_m_id = User.current.m_id
  end

  # Must be implemented in subclasses.
  # Returns hash of parameters for single transaction.
  def params(*args)
    raise NotImplementedError
  end

  # Configure transaction confirmations - objects in the database
  # that are created/edited/destroyed by the transaction.
  # The actions will be confirmed only when the transaction
  # successfully finishes.
  class Confirmable
    def initialize(t)
      @transaction = t
    end

    # Create an object. Pass the object as an argument.
    def create(*args)
      add_confirmable(:create_type, *args)
    end

    # Destroy an object. Pass the object as an argument.
    def destroy(*args)
      add_confirmable(:destroy_type, *args)
    end

    # Edit hash of attributes +attrs+ of an object +obj+.
    def edit(obj, attrs)
      add_confirmable(:edit_type, obj, attrs)
    end

    protected
    def add_confirmable(type, obj, attrs = nil)
      pk = obj.class.primary_key
      pks = {}

      if pk.is_a?(Array)
        pk.each { |col| pks[col] = obj.send(col) }

      else
        pks[pk] = obj.id
      end

      ::TransactionConfirmation.create(
          parent_transaction: @transaction,
          class_name: obj.class.name,
          table_name: obj.class.table_name,
          row_pks: pks,
          attr_changes: attrs,
          confirm_type: type
      )
    end
  end
end

module Transactions
  module Vps

  end

  module Storage

  end
end
