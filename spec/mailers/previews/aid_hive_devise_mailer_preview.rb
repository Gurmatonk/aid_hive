class AidHiveDeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions_de
    I18n.locale = :de
    AidHiveDeviseMailer.confirmation_instructions(User.first, 'faketoken')
  end

  def confirmation_instructions_en
    I18n.locale = :en
    AidHiveDeviseMailer.confirmation_instructions(User.first, 'faketoken')
  end

  def reset_password_instructions_confirmed_de
    I18n.locale = :de
    AidHiveDeviseMailer.reset_password_instructions(User.first, 'faketoken')
  end

  def reset_password_instructions_unconfirmed_de
    I18n.locale = :de
    user = User.first
    user.confirmed_at = nil
    AidHiveDeviseMailer.reset_password_instructions(user, 'faketoken')
  end

  def reset_password_instructions_confirmed_en
    I18n.locale = :en
    AidHiveDeviseMailer.reset_password_instructions(User.first, 'faketoken')
  end

  def reset_password_instructions_unconfirmed_en
    I18n.locale = :en
    user = User.first
    user.confirmed_at = nil
    AidHiveDeviseMailer.reset_password_instructions(user, 'faketoken')
  end
end
