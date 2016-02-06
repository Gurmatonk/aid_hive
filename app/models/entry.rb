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
  has_one :thread, as: :commontable, class_name: 'Commontator::Thread'
  has_many :comments, through: :thread, class_name: 'Commontator::Comment'
  has_many :commenters, -> { uniq }, as: :creator, source: :creator, through: :comments, source_type: 'User'

  validates :title, presence: true
  validates :description, presence: true
end
