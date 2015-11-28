class User < ActiveRecord::Base
  PRIVATE_CONVERSATION_SUBJECT = 'Private Conversation'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :zxcvbnable
  geocoded_by :full_street_address
  acts_as_commontator
  acts_as_messageable
  nilify_blanks

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

  def mailboxer_email(mailboxer_object)
    email
  end

  def private_conversations
    mailbox.conversations.where(subject: PRIVATE_CONVERSATION_SUBJECT)
  end

  def private_conversation_with(user)
    private_conversations.participant(user).first
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
