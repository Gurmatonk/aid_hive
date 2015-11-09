class Entry < ActiveRecord::Base
  geocoded_by :full_street_address

  belongs_to :user, inverse_of: :entries

  validates :title, presence: true
  validates :description, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true

  after_validation :geocode

  def full_street_address
    result = "#{street_name} #{street_number}, " if street_name.present?
    "#{result}#{postal_code} #{city}"
  end
end
