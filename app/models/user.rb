class User < ActiveRecord::Base
  include Locatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :zxcvbnable
  acts_as_commontator
  acts_as_messageable
  nilify_blanks

  PRIVATE_CONVERSATION_SUBJECT = 'Private Conversation'

  enum role: [:user, :vip, :admin]

  has_many :entries, inverse_of: :user
  has_many :offers
  has_many :requests

  validates :email, presence: true
  validates :name, presence: true, uniqueness: true

  after_initialize :set_default_role, if: :new_record?

  def mailboxer_email(_mailboxer_object)
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
