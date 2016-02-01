feature 'About page' do
  scenario 'Visit the about page' do
    visit 'pages/about'
    expect(page).to have_content 'About Aid Hive'
  end
end
