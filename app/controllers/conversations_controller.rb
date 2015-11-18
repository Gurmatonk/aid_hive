class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox

  def index
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end
end
