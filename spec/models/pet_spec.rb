require 'rails_helper'

describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it {should have_many(:pet_applications)}
    it {should have_many(:applications).through(:pet_applications)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe "instance methods" do
    before :each do
      @app1 = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "pending")
      @app2 = Application.create!(name: "name1", street: "123 abc st.", city: "city", state: "state", zip: "92018", description: "Some words", status: "pending")

      @shelter = Shelter.create!(name: "Good Home")

      @pet1 = @shelter.pets.create!(name: "Buddy", approximate_age: 3, description: "A good boy", sex: "male")
      @pet2 = @shelter.pets.create!(name: "Duke", approximate_age: 3, description: "A good boy", sex: "male")
      @pet3 = @shelter.pets.create!(name: "Bubbu", approximate_age: 3, description: "A good boy", sex: "male")

      @app1_pet1 = PetApplication.create!(pet: @pet1, application: @app1)
      @app1_pet2 = PetApplication.create!(pet: @pet2, application: @app1, approved: true)
      @app1_pet3 = PetApplication.create!(pet: @pet3, application: @app1, approved: false)
      @app2_pet2 = PetApplication.create!(pet: @pet2, application: @app2)
    end

    it "#not_reviewed?" do
      expect(@pet1.not_reviewed?(@app1.id)).to eq(true)
      expect(@pet2.not_reviewed?(@app1.id)).to eq(false)
      expect(@pet3.not_reviewed?(@app1.id)).to eq(false)
    end

    it "#approved?" do
      expect(@pet1.approved?(@app1.id)).to eq(false)
      expect(@pet2.approved?(@app1.id)).to eq(true)
      expect(@pet3.approved?(@app1.id)).to eq(false)
    end

    it "#adopt" do
      expect(@pet1.adoptable).to eq(true)

      @pet1.adopt

      expect(@pet1.adoptable).to eq(false)
    end

    it "#approved_applications?" do
      expect(@pet2.approved_application?).to eq(true)
    end
  end
end
