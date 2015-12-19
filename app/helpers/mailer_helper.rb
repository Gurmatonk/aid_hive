module MailerHelper
  include ApplicationHelper

  def t_mail(key, options = {})
    t_scoped_with_common_fallback key, :mails, [@mail_scope], options
  end
end
