require 'rails_helper'

RSpec.describe "Admin application show page" do
  before :each do
    @app1 = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app2 = Application.create!(name: "name2", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app3 = Application.create!(name: "name3", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app4 = Application.create!(name: "name4", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "pending")

    @shelter = Shelter.create!(name: "Good Home")

    @pet1 = @shelter.pets.create!(name: "Buddy", approximate_age: 3, description: "A good boy", sex: "male")
    @pet2 = @shelter.pets.create!(name: "Duke", approximate_age: 3, description: "A good boy", sex: "male")
    @pet3 = @shelter.pets.create!(name: "Bubbu", approximate_age: 3, description: "A good boy", sex: "male")
    @pet4 = @shelter.pets.create!(name: "Dragon", approximate_age: 4, description: "A big boy", sex: "male")

    @app1_pet1 = PetApplication.create!(pet: @pet1, application: @app1)
    @app1_pet2 = PetApplication.create!(pet: @pet2, application: @app1)
    @app2_pet2 = PetApplication.create!(pet: @pet2, application: @app2)
    @app2_pet3 = PetApplication.create!(pet: @pet3, application: @app2)
    @app3_pet3 = PetApplication.create!(pet: @pet3, application: @app3)
    @app3_pet4 = PetApplication.create!(pet: @pet4, application: @app3)
    @app4_pet4 = PetApplication.create!(pet: @pet4, application: @app4)
    @app4_pet1 = PetApplication.create!(pet: @pet1, application: @app4)
  end

  describe "when I visit the admin application show page" do
    describe "for each pet on the application" do
      describe "Approve funtionality" do
        it "shows an approve button" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              expect(page).to have_button("Approve")
            end

            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Approve")
            end
          end
        end

        it "changes the pets status to approved when clicked" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              click_button("Approve")
              expect(page).to_not have_button("Approve")
              expect(page).to have_content("Approved")
            end

            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Approve")
            end
          end
        end
      end

      describe "Reject funtionality" do
        it "shows a reject button" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              expect(page).to have_button("Reject")
            end

            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Reject")
            end
          end
        end

        it "changes the pets status to rejected when clicked" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              click_button("Reject")
              expect(page).to_not have_button("Reject")
              expect(page).to have_content("Rejected")
            end

            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Reject")
            end
          end
        end
      end

      describe "pet approval or rejection on an applicvation" do
        it "does not effect other applications" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              click_button("Reject")
            end
          end

          visit "/admin/applications/#{@app2.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Approve")
              expect(page).to have_button("Reject")
            end
          end
        end
      end

      describe "When all pets an an applicastion are approved" do
        it "changes status to Approved" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              click_button("Approve")
            end
          end

          expect(page).to have_content("Status: Pending")

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              click_button("Approve")
            end
          end

          expect(page).to have_content("Status: Approved")
        end

        it "makes all pets on the application not adoptable" do
          expect(@pet1.adoptable).to eq(true)

          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              click_button("Approve")
            end

            within("#pet-#{@pet2.id}") do
              click_button("Approve")
            end
          end
          visit "/pets/#{@pet1.id}"

          expect(page).to have_content("false")
        end
      end

      describe "When one or more pets are rejected and all others are approved" do
        it "changed the application status to rejected" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet1.id}") do
              click_button("Reject")
            end
          end

          expect(page).to have_content("Status: Pending")

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              click_button("Approve")
            end
          end

          expect(page).to have_content("Status: Rejected")
        end
      end

      describe "when a pet is approved on another application" do
        it " shows a message that the pet is approved on another application" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              click_button("Approve")
            end
          end

          visit "/admin/applications/#{@app2.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              expect(page).to have_content("This pet has already been approved for adoption")
            end
          end
        end

        it "doesn't show an approve button, but still shows a reject button" do
          visit "/admin/applications/#{@app1.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              click_button("Approve")
            end
          end

          visit "/admin/applications/#{@app2.id}"

          within(".application_pets") do
            within("#pet-#{@pet2.id}") do
              expect(page).to have_button("Reject")
              expect(page).to_not have_button("Approve")
            end
          end
        end
      end
    end
  end
end
