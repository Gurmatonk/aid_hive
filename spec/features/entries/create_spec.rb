[:offer, :request].each do |entry|
  feature "Create #{entry}" do
    let!(:user) { FactoryGirl.create(:user, :confirmed) }
    let(:model) { entry.to_s.classify.constantize }

    context 'not signed in' do
      scenario 'user cannot access form' do
        visit send("new_#{entry}_path")
        expect(page).to have_content(I18n.t(:unauthenticated, scope: [:devise, :failure]))
      end
    end

    context 'signed in' do
      let :values do
        {
          Entry.human_attribute_name(:title) => 'This is a nice title',
          Entry.human_attribute_name(:description) => 'This is a descriptive description',
          Entry.human_attribute_name(:postal_code) => '70180',
          Entry.human_attribute_name(:city) => 'Stuttgart',
          Entry.human_attribute_name(:street_name) => 'Pelargusstraße',
          I18n.t('views.common.street_number') => '1'
        }
      end
      let(:location) { 'Pelargusstraße 1, 70180 Stuttgart' }

      before(:each) do
        sign_in(user.email, user.password)
        visit send("new_#{entry}_path")
      end

      subject { click_button(I18n.t('helpers.submit.create', model: model.model_name.human)) }

      # TODO: Test without optional attributes and error messages for required attributes
      scenario "user can create a new #{entry} with all attributes" do
        values.each { |field, value| fill_in(field, with: value) }
        subject
        expect(page).to have_content(I18n.t(:success, scope: [:controllers, entry.to_s.pluralize, :create]))
        expect(page).to have_content([model.human_attribute_name(:status), model.human_attribute_value(:status, :open)].join(' '))
        expect(page).to have_content([model.human_attribute_name(:user), I18n.t('views.common.you')].join(' '))
        expect(page).to have_content([model.human_attribute_name(:description), values[Entry.human_attribute_name(:description)]].join(' '))
        expect(page).to have_content([model.human_attribute_name(:location), location].join(' '))
      end
    end
  end
end
