class ApiToken < ActiveRecord::Base
  belongs_to :user
  has_many :user_sessions

  validates :user_id, :token, presence: true
  validates :token, length: {is: 100}

  enum lifetime: %i(fixed renewable_manual renewable_auto permanent)

  def self.generate
    SecureRandom.hex(50)
  end

  def self.custom(*args)
    t = new(*args)
    t.token = generate
    t.valid_to = t.lifetime != 'permanent' ? Time.now + t.interval : nil
    t
  end

  def renew
    self.valid_to = Time.now + interval
  end
end
