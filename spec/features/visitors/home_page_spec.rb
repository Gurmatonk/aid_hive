feature 'Home page' do
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_content 'Willkommen auf Aid Hive'
  end
end
