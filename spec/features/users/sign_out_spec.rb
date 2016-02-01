feature 'Sign out', :devise do
  scenario 'user signs out successfully' do
    user = FactoryGirl.create(:user)
    user.confirm
    sign_in(user.email, user.password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
    click_link 'Log out'
    expect(page).to have_content I18n.t 'devise.sessions.signed_out'
  end
end
