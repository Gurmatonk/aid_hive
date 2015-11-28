class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_recipient, only: [:new, :create]

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      existing_conversation = current_user.private_conversation_with(@recipient)
      if existing_conversation.present?
        current_user.reply_to_conversation(existing_conversation, params[:message][:body])
      else
        current_user.send_message(@recipient, params[:message][:body], User::PRIVATE_CONVERSATION_SUBJECT)
      end
      redirect_to :back, notice: 'Message has been sent.'
    end
  end

  private

  def load_recipient
    @recipient = User.find_by_id(params[:recipient_id])
    redirect_to_back alert: 'Receiver does not exist' if @recipient.nil?
  end
end
