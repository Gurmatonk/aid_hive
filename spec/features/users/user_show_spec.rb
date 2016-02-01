include Warden::Test::Helpers
Warden.test_mode!

feature 'User profile page', :devise do
  after(:each) do
    Warden.test_reset!
  end

  let(:user_traits) { [] }
  let!(:user) { FactoryGirl.create(:user, *user_traits).tap(&:confirm) }

  before(:each) { login_as(user, scope: :user, run_callbacks: false) }

  shared_examples_for 'user seeing full profile' do
    scenario "including the user's email" do
      subject
      expect(page).to have_content 'User'
      expect(page).to have_content viewd_user.email
      expect(page).to have_content viewd_user.name
      expect(page).to have_content viewd_user.address_line
    end
  end

  feature 'user sees own profile' do
    subject { visit user_path(user) }

    it_behaves_like 'user seeing full profile' do
      let(:viewd_user) { user }
    end
  end

  context "other user's profile" do
    let!(:other_user) { FactoryGirl.create(:user).tap(&:confirm) }

    subject { visit user_path(other_user) }

    context 'user is admin' do
      let(:user_traits) { super() << :admin }

      it_behaves_like 'user seeing full profile' do
        let(:viewd_user) { other_user }
      end
    end

    context 'user is not admin' do
      scenario "user can see another user's profile without his email" do
        Capybara.current_session.driver.header 'Referer', root_path
        subject
        expect(page).to have_content 'Access denied.'
      end
    end
  end
end
