[:offer, :request].each do |entry|
  feature "Edit #{entry}" do
    let!(:user) { FactoryGirl.create(:user, :confirmed) }
    let(:model) { entry.to_s.classify.constantize }

    let(:instance) { FactoryGirl.create(entry, user: user) }

    context 'not signed in' do
      scenario 'user cannot access form' do
        visit send("edit_#{entry}_path", instance)
        expect(page).to have_content(I18n.t(:unauthenticated, scope: [:devise, :failure]))
      end
    end

    shared_examples_for 'authorized for editing' do
      let :values do
        {
          Entry.human_attribute_name(:title) => 'This is a nice title',
          Entry.human_attribute_name(:description) => 'This is a descriptive description',
          Entry.human_attribute_name(:postal_code) => '67663',
          Entry.human_attribute_name(:city) => 'Kaiserslautern',
          Entry.human_attribute_name(:street_name) => 'Balbierstraße',
          I18n.t('views.common.street_number') => '8'
        }
      end
      let(:location) { 'Balbierstraße 8, 67663 Kaiserslautern' }

      subject { click_button(I18n.t('helpers.submit.update', model: model.model_name.human)) }

      context 'with all attributes filled in' do
        scenario "user can edit own #{entry}" do
          values.each { |field, value| fill_in(field, with: value) }
          expect { subject }.to change(instance, :attributes)
          expect(page).to have_content(I18n.t(:success, scope: [:controllers, entry.to_s.pluralize, :create]))
          expect(page).to have_content([model.human_attribute_name(:status), model.human_attribute_value(:status, :open)].join(' '))
          expect(page).to have_content([model.human_attribute_name(:user), I18n.t('views.common.you')].join(' '))
          expect(page).to have_content([model.human_attribute_name(:description), values[Entry.human_attribute_name(:description)]].join(' '))
          expect(page).to have_content([model.human_attribute_name(:location), location].join(' '))
        end
      end

      context 'with all required attributes filled in' do
        let :values do
          super().tap do |hash|
            hash.delete Entry.human_attribute_name(:street_name)
            hash.delete I18n.t('views.common.street_number')
          end
        end
        let(:location) { '70180 Stuttgart' }

        scenario "user can edit own #{entry}" do
          values.each { |field, value| fill_in(field, with: value) }
          expect { subject }.to change(instance, :attributes)
          expect(page).to have_content(I18n.t(:success, scope: [:controllers, entry.to_s.pluralize, :create]))
          expect(page).to have_content([model.human_attribute_name(:status), model.human_attribute_value(:status, :open)].join(' '))
          expect(page).to have_content([model.human_attribute_name(:user), I18n.t('views.common.you')].join(' '))
          expect(page).to have_content([model.human_attribute_name(:description), values[Entry.human_attribute_name(:description)]].join(' '))
          expect(page).to have_content([model.human_attribute_name(:location), location].join(' '))
        end
      end

      [Entry.human_attribute_name(:title), Entry.human_attribute_name(:description), Entry.human_attribute_name(:postal_code), Entry.human_attribute_name(:city)].each do |attr|
        context "without required attribute #{attr}" do
          # TODO: This fails, i.e. it does not fail for postal code and city.
          scenario "user cannot create a new #{entry}" do
            values.each { |field, value| fill_in(field, with: value) }
            fill_in attr, with: ''
            expect { subject }.not_to change(instance, :attributes)
            expect(page).to have_content([attr, I18n.t(:blank, scope: [:errors, :messages])].join(''))
          end
        end
      end
    end

    context 'signed in as other user' do
      let(:other_user) { FactoryGirl.create(:user, user_trait, :confirmed) }

      before(:each) do
        sign_in(other_user.email, other_user.password)
        visit send("edit_#{entry}_path", instance)
      end

      [:moderator, :user].each do |role|
        context "with role #{role}" do
          let(:user_trait) { role }

          scenario 'cannot access edit action' do
            expect(page).to have_content(I18n.t(:default, scope: :pundit))
          end
        end
      end

      context 'with role admin' do
        let(:user_trait) { :admin }

        it_behaves_like 'authorized for editing'
      end
    end

    context 'signed in' do
      before(:each) do
        sign_in(user.email, user.password)
        visit send("edit_#{entry}_path", instance)
      end

      it_behaves_like 'authorized for editing'
    end
  end
end
