class Entry < ActiveRecord::Base
  include AASM

  geocoded_by :full_street_address
  acts_as_commontable
  nilify_blanks

  enum status: {open: 0, completed: 1}

  aasm column: :status, enum: true do
    state :open, initial: true
    state :completed

    event :complete do
      transitions from: :open, to: :completed
    end
  end

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
