require 'rails_helper'

RSpec.describe "application show page" do
  before :each do
    @app = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app2 = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Submitted")

    @shelter = Shelter.create!(name: "Good Home")

    @pet1 = @shelter.pets.create!(name: "Buddy", approximate_age: 3, description: "A good boy", sex: "male")
    @pet2 = @shelter.pets.create!(name: "Duke", approximate_age: 3, description: "A good boy", sex: "male")
    @pet3 = @shelter.pets.create!(name: "Bubbu", approximate_age: 3, description: "A good boy", sex: "male")
    @pet4 = @shelter.pets.create!(name: "Dragon", approximate_age: 4, description: "A big boy", sex: "male")

    @app1_pet1 = PetApplication.create!(pet: @pet1, application: @app)
    @app1_pet3 = PetApplication.create!(pet: @pet3, application: @app)
  end

  describe "when I visit the application show page" do
    it "shows the application, name, address, description, list of pets, and status" do
      visit "/applications/#{@app.id}"

      expect(page).to have_content(@app.name)
      expect(page).to have_content(@app.street)
      expect(page).to have_content(@app.city)
      expect(page).to have_content(@app.state)
      expect(page).to have_content(@app.zip)
      expect(page).to have_link(@pet1.name)
      expect(page).to have_link(@pet3.name)
      expect(page).to have_content(@app.status)
    end

    describe "and the application has not been submitted" do
      it "shows a section on the page to 'Add a Pet to this Application'" do
        visit "/applications/#{@app.id}"

        expect(page).to have_field("search")
        expect(page).to have_button("Search")
      end

      # sad path test
      it "doesnt show a search field if the application has been submitted" do
        visit "/applications/#{@app2.id}"

        expect(page).to_not have_field("search")
        expect(page).to_not have_button("Search")
      end

      describe "when a search is submitted" do

        it "shows a list of pets under the search bar" do
          visit "/applications/#{@app.id}"

          fill_in "search", with: "Bu"
          click_button "Search"

          expect(current_path).to eq("/applications/#{@app.id}")

          expect(page).to have_content(@pet1.name)
          expect(page).to have_content(@pet3.name)
          expect(page).to_not have_content(@pet2.name)
        end

        it "shows a button to adopt each pet next to it's name" do
          visit "/applications/#{@app.id}"

          fill_in "search", with: "Bu"
          click_button "Search"

          expect(page).to have_link("add_pet_#{@pet1.id}")
          expect(page).to_not have_link("add_pet_#{@pet2.id}")
          expect(page).to have_link("add_pet_#{@pet3.id}")
        end

        it "Adds the pet to the application when its corisponding Link is clicked" do
          visit "/applications/#{@app.id}"

          fill_in "search", with: "Drag"
          click_button "Search"

          click_link "add_pet_#{@pet4.id}"

          within(".application_pets") do
            expect(page).to have_link(@pet4.name)
          end
        end
      end
    end
  end
end
