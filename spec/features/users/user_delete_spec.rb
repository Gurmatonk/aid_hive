include Warden::Test::Helpers
Warden.test_mode!

feature 'User delete', :devise, :js do
  after(:each) do
    Warden.test_reset!
  end

  let(:user) { FactoryGirl.create(:user).tap(&:confirm) }

  scenario 'user can delete his own account' do
    login_as user, scope: :user, run_callbacks: false
    visit edit_user_registration_path(user)
    page.accept_confirm do
      click_button I18n.t('views.devise.registrations.edit.cancel_button')
    end
    expect(User.find_by_id(user.id)).to be_nil
  end
end
