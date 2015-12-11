class AidHiveDeviseMailer < Devise::Mailer
  helper MailerHelper

  default from: 'no-reply@aid-hive.org'

  SUBJECT_PREFIX = Rails.env.production? ? '[aid hive] ' : "[aid hive - #{Rails.env} system]"

  def confirmation_instructions(resource, token, opts = {})
    opts[:subject] = subject(:confirmation_instructions)
    super
  end

  def reset_password_instructions(resource, token, opts = {})
    if resource.confirmed_at.nil?
      opts[:subject] = subject(:confirmation_instructions)
    else
      opts[:subject] = subject(:reset_password_instructions)
    end
    super
  end

  # def unlock_instructions(resource, token, opts = {})
  #   opts[:subject] = subject(:unlock_instructions)
  #   super
  # end

  private

  def subject(key)
    "#{SUBJECT_PREFIX} #{I18n.t :subject, scope: [:devise, :mailer, key]}"
  end
end
