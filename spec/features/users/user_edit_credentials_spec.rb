include Warden::Test::Helpers
Warden.test_mode!

feature 'User edit credentials', :devise do
  after(:each) do
    Warden.test_reset!
  end

  let(:user_traits) { [] }
  let!(:user) { FactoryGirl.create(:user, *user_traits).tap(&:confirm) }

  before(:each) { login_as(user, scope: :user, run_callbacks: false) }

  context 'editing own credentials' do
    before(:each) { visit(edit_user_registration_path(user)) }

    scenario 'user changes email address' do
      fill_in 'Email', with: 'newemail@example.com'
      fill_in 'Current password', with: user.password
      click_button 'Update'
      expect(page).to have_content(I18n.t('devise.registrations.update_needs_confirmation'))
    end

    scenario 'user changes password' do
      new_password = 'this is my new really secure password - so long'
      fill_in 'Password', with: new_password
      fill_in 'Password confirmation', with: new_password
      fill_in 'Current password', with: user.password
      click_button 'Update'
      expect(page).to have_content(I18n.t('devise.registrations.updated'))
      expect(user.reload.valid_password?(user.password)).to be_falsy
      expect(user.reload.valid_password?(new_password)).to be_truthy
    end
  end

  context 'different user' do
    scenario 'user cannot access edit credential page for another user' do
      other = FactoryGirl.create(:user, email: 'other@example.com')
      visit edit_user_registration_path(other)
      expect(page).to have_content 'Edit login data'
      expect(page).to have_field('Email', with: user.email)
      expect(page).not_to have_field('Email', with: other.email)
    end
  end
end
