require 'rails_helper'

RSpec.describe Application, type: :model do
  describe "relationships" do
    it {should have_many(:pet_applications)}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe "instance methods"

  before :each do
    @app1 = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "In Progress")
    @app2 = Application.create!(name: "name2", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app3 = Application.create!(name: "name3", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")
    @app4 = Application.create!(name: "name4", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "Pending")

    @shelter = Shelter.create!(name: "Good Home")

    @pet1 = @shelter.pets.create!(name: "Buddy", approximate_age: 3, description: "A good boy", sex: "male")
    @pet2 = @shelter.pets.create!(name: "Duke", approximate_age: 3, description: "A good boy", sex: "male")

    @app1_pet1 = PetApplication.create!(pet: @pet1, application: @app1, approved: true)
    @app1_pet2 = PetApplication.create!(pet: @pet2, application: @app2, approved: true)
    @app2_pet1 = PetApplication.create!(pet: @pet1, application: @app2, approved: false)
    @app2_pet2 = PetApplication.create!(pet: @pet2, application: @app2, approved: true)
    @app3_pet2 = PetApplication.create!(pet: @pet1, application: @app3, approved: true)
    @app3_pet2 = PetApplication.create!(pet: @pet2, application: @app3, approved: nil)
  end

  it "#has_pets?" do
    expect(@app1.has_pets?).to eq(true)
    expect(@app4.has_pets?).to eq(false)
  end

  it "#in_progress?" do
    expect(@app1.in_progress?).to eq(true)
    expect(@app2.in_progress?).to eq(false)
  end

  it "#ready_to_submit?" do
    expect(@app1.ready_to_submit?).to eq(true)
    expect(@app2.ready_to_submit?).to eq(false)
  end

  it "#submitted?" do
    expect(@app1.submitted?).to eq(false)
    expect(@app2.submitted?).to eq(true)
  end

  it "#approved?" do
    @app1.approved?
    @app2.approved?
    @app3.approved?

    expect(@app1.status).to eq("Approved")
    expect(@app2.status).to eq("Rejected")
    expect(@app3.status).to eq("Pending")
  end
end
