class User < ActiveRecord::Base
  include Locatable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :confirmable, :database_authenticatable, :invitable, :recoverable, :registerable, :rememberable, :trackable, :validatable, :zxcvbnable
  devise :omniauthable, omniauth_providers: [:facebook]
  acts_as_commontator
  acts_as_messageable
  nilify_blanks

  PRIVATE_CONVERSATION_SUBJECT = 'Private Conversation'.freeze

  enum role: [:user, :moderator, :admin]

  has_many :entries, inverse_of: :user
  has_many :offers
  has_many :requests
  has_many :comments, as: :creator, class_name: 'Commontator::Comment'
  has_many :threads, through: :comments, class_name: 'Commontator::Thread'
  has_many :commented_offers, -> { uniq }, through: :threads, source: :commontable, source_type: 'Entry', class_name: 'Offer'
  has_many :commented_requests, -> { uniq }, through: :threads, source: :commontable, source_type: 'Entry', class_name: 'Request'

  validates :email, presence: true
  validates :name, presence: true, uniqueness: true

  after_initialize :set_default_role, if: :new_record?

  def self.from_omniauth(auth)
    where(oauth_provider: auth.provider, oauth_uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token(72)
      user.name = auth.info.name
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data']) && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
        user.name = data['name'] if user.name.blank?
      end
    end
  end

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
