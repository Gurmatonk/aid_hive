class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_recipient, only: [:new, :create]

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      #conversation = current_user.send_message(@recipient, params[:message][:body], params[:message][:subject]).conversation
      #redirect_to conversation_path(conversation), notice: 'Message has been sent.'
      current_user.send_message(@recipient, params[:message][:body], params[:message][:subject] || 'No subject')
      redirect_to :back, notice: 'Message has been sent.'
    end
  end

  private

  def load_recipient
    @recipient = User.find_by_id(params[:recipient_id])
    redirect_to_back alert: 'Receiver does not exist' if @recipient.nil?
  end
end
