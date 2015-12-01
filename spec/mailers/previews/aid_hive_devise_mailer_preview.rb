class AidHiveDeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    AidHiveDeviseMailer.confirmation_instructions(User.first, "faketoken")
  end

  def reset_password_instructions
    AidHiveDeviseMailer.reset_password_instructions(User.first, "faketoken")
  end
end
