class AidHiveDeviseMailer < Devise::Mailer
  helper MailerHelper

  default from: 'no-reply@aid-hive.org'

  SUBJECT_PREFIX = Rails.env.production? ? '[aid hive] ' : "[aid hive - #{Rails.env} system]"

  def confirmation_instructions(resource, token, opts = {})
    set_demo_hint
    opts[:subject] = subject(:confirmation_instructions)
    super
  end

  def reset_password_instructions(resource, token, opts = {})
    set_demo_hint
    opts[:subject] = subject(:reset_password_instructions)
    super
  end

  def reset_password_instructions(resource, token, opts = {})
    set_demo_hint
    opts[:subject] = subject(:unlock_instructions)
    super
  end

  private

  def subject(key)
    "#{SUBJECT_PREFIX} #{I18n.t :subject, scope: [:devise, :mailer, key]}"
  end

  def set_demo_hint
    @demo_hint = "Diese E-Mail wurde vom Aid Hive Demo-System versendet! This email was sent by the Aid Hive demo system"
  end
end
