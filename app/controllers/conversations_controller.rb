class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :load_conversation, only: [:show, :reply]

  def index
    @selected_conversation = params[:conversation_id].present? ? Mailboxer::Conversation.find_by_id(params[:conversation_id]) : @mailbox.conversations.first
    @selected_conversation.mark_as_read(current_user)
    @receipts = @selected_conversation.receipts_for(current_user).order(created_at: :asc)
  end

  def show
    @receipts = @conversation.receipts_for(current_user).order(created_at: :asc)
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    redirect_to conversations_path(conversation_id: @conversation.id)
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def load_conversation
    @conversation = Mailboxer::Conversation.find_by_id(params[:id])
  end
end
