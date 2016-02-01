feature 'Sign Up', :devise do
  let(:secure_password) { 'please123 i have a really secure password here' }

  # TODO: extend tests with location
  scenario 'visitor can sign up with valid email address and password' do
    sign_up_with('Test user', 'test@example.com', secure_password, secure_password)
    expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
  end

  scenario 'visitor cannot sign up with invalid email address' do
    sign_up_with('Test user', 'bogus', secure_password, secure_password)
    expect(page).to have_content 'Email is invalid'
  end

  scenario 'visitor cannot sign up without password' do
    sign_up_with('Test user', 'test@example.com', '', '')
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'visitor cannot sign up with a short password' do
    sign_up_with('Test user', 'test@example.com', 'please', 'please')
    expect(page).to have_content 'Password is too short'
  end

  scenario 'visitor cannot sign up without password confirmation' do
    sign_up_with('Test user', 'test@example.com', 'please123', '')
    expect(page).to have_content "Password confirmation doesn't match"
  end

  scenario 'visitor cannot sign up with mismatched password and confirmation' do
    sign_up_with('Test user', 'test@example.com', 'please123', 'mismatch')
    expect(page).to have_content "Password confirmation doesn't match"
  end
end
