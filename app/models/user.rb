class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable
  geocoded_by :full_street_address
  acts_as_commontator
  acts_as_messageable

  enum role: [:user, :vip, :admin]

  has_many :entries, inverse_of: :user
  has_many :offers
  has_many :requests

  after_initialize :set_default_role, :if => :new_record?

  after_validation :geocode

  def full_street_address
    result = "#{street_name} #{street_number}, " if street_name.present?
    "#{result}#{postal_code} #{city}"
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
