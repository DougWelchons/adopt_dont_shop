PetApplication.destroy_all
Pet.destroy_all
Shelter.destroy_all
Application.destroy_all

@app1 = Application.create!(name: "John Smith", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "In Progress")
@app2 = Application.create!(name: "Betty Ross", street: "234 abc st.", city: "city", state: "state", zip: "92018", description: "Something Nice", status: "In Progress")
@app3 = Application.create!(name: "Phil Parker", street: "345 abc st.", city: "city", state: "state", zip: "92018", description: "I could do it", status: "Pending")
@app4 = Application.create!(name: "Patty Collens", street: "456 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")

@shelter = Shelter.create!(name: "Good Home")
@shelter2 = Shelter.create!(name: "Good Home2")
@shelter3 = Shelter.create!(name: "Good Home3")
@shelter4 = Shelter.create!(name: "Good Home4")

@pet1 = @shelter.pets.create!(name: "Buddy", approximate_age: 3, description: "A good Dog", sex: "male")
@pet2 = @shelter.pets.create!(name: "Duke", approximate_age: 1, description: "A good boy", sex: "male")
@pet3 = @shelter.pets.create!(name: "Bubbu", approximate_age: 5, description: "Very loving", sex: "male")
@pet4 = @shelter.pets.create!(name: "Blake", approximate_age: 2, description: "Crazy", sex: "male")
@pet5 = @shelter.pets.create!(name: "Bonie", approximate_age: 2, description: "Kind and Gentle", sex: "female")
@pet6 = @shelter.pets.create!(name: "Mocha", approximate_age: 3, description: "A good boy", sex: "female")

@app1_pet1 = PetApplication.create!(pet: @pet1, application: @app1)
@app1_pet2 = PetApplication.create!(pet: @pet2, application: @app1)
@app1_pet3 = PetApplication.create!(pet: @pet3, application: @app1)
@app3_pet3 = PetApplication.create!(pet: @pet6, application: @app3)
@app3_pet3 = PetApplication.create!(pet: @pet1, application: @app3)
@app3_pet3 = PetApplication.create!(pet: @pet3, application: @app3)
@app4_pet3 = PetApplication.create!(pet: @pet5, application: @app4)
