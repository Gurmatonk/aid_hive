feature 'Sign in', :devise do
  describe 'unregistered user' do
    scenario 'user cannot sign in if not registered' do
      sign_in 'test@example.com', 'please123'
      expect(page).to have_content(I18n.t('devise.failure.not_found_in_database', authentication_keys: 'email'))
    end
  end

  describe 'registered user' do
    let!(:user) { FactoryGirl.create(:user) }

    shared_examples_for 'denying access for invalid credentials' do
      scenario 'user cannot sign in with wrong email' do
        sign_in 'invalid@email.com', user.password
        expect(page).to have_content(I18n.t('devise.failure.not_found_in_database', authentication_keys: 'email'))
      end

      scenario 'user cannot sign in with wrong password' do
        sign_in user.email, 'invalidpass'
        expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
      end
    end

    context 'unconfirmed' do
      it_behaves_like 'denying access for invalid credentials'

      scenario 'user is notified about missing confirmation for sign in with valid credentials' do
        sign_in user.email, user.password
        expect(page).to have_content(I18n.t('devise.failure.unconfirmed'))
      end
    end

    context 'confirmed' do
      before(:each) { user.confirm }

      it_behaves_like 'denying access for invalid credentials'

      scenario 'user can sign in with valid credentials' do
        sign_in user.email, user.password
        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
      end
    end
  end
end
