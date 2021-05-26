require 'rails_helper'

RSpec.describe 'application show page' do
  before(:each) do
    @shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @pet_1 = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @pet_2 = Pet.create!(name: 'Breadbox', age: 5, breed: 'Golden Lab', adoptable: true, shelter_id: @shelter.id)
    @pet_3 = Pet.create!(name: 'Lemon', age: 12, breed: 'Chihuaha', adoptable: true, shelter_id: @shelter.id)
    @application = Application.create!(name: 'June Harrity', street_address: '123 Pine St', city: 'Loganville', state: 'Georiga', zip_code: 30052, description: 'Because I am awesome.', status: "In Progress")
  end

  it 'can show the name, full address, and description for the application' do
    visit "/applications/#{@application.id}"

    expect(page).to have_content("#{@application.name}")
    expect(page).to have_content("#{@application.street_address}")
    expect(page).to have_content("#{@application.city}")
    expect(page).to have_content("#{@application.state}")
    expect(page).to have_content("#{@application.zip_code}")
    expect(page).to have_content("#{@application.description}")
  end

  it 'has name links to each pet associated with the application' do
    @application.pets << @pet_1
    @application.pets << @pet_2
    @application.pets << @pet_3
    visit "/applications/#{@application.id}"

    expect(page).to have_link("#{@pet_1.name}", href: "/pets/#{@pet_1.id}")
    expect(page).to have_link("#{@pet_2.name}", href: "/pets/#{@pet_2.id}")
    expect(page).to have_link("#{@pet_3.name}", href: "/pets/#{@pet_3.id}")
  end

  it 'shows the status of the application' do
    visit "/applications/#{@application.id}"

    expect(page).to have_content("#{@application.status}")
  end

  it 'has a section to add a pet to this application' do
    visit "/applications/#{@application.id}"

    expect(page).to have_content("Add a Pet to this Application")
    expect(page).to have_css('#pet_search')
    expect(page).to have_button('Search')
  end

  it 'redirects the user to show page with a list of matching pets' do
    visit "/applications/#{@application.id}"

    fill_in('Add a Pet to this Application', with: 'Scooby')
    click_on('Search')

    expect(current_path).to eq("/applications/#{@application.id}")
    expect(page).to have_content('Scooby')
    save_and_open_page
  end
end
