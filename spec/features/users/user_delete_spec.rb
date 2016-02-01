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
    # TODO: Figure out how the captions can be fetched by I18n.t and client and server having the same language set.
    #       Replace last expect by proper feature style test with sign_in and test for error message.
    page.accept_confirm do
      click_button 'Mein Benutzerkonto löschen'
    end
    expect(User.find_by_id(user.id)).to be_nil
  end
end
