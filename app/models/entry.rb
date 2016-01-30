class Entry < ActiveRecord::Base
  include AASM
  include Locatable

  acts_as_commontable
  nilify_blanks
  require_locatable_attributes

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
end
