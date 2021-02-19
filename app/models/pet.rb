class Pet < ApplicationRecord
  belongs_to :shelter
  validates_presence_of :name, :description, :approximate_age, :sex

  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }

  enum sex: [:female, :male]
  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def not_reviewed?(application_id)
    record = PetApplication.where(pet_id: id, application_id: application_id).first
    record.approved == nil
  end

  def approved?(application_id)
    record = PetApplication.where(pet_id: id, application_id: application_id).first
    record.approved == true
  end

  def adopt
    update(adoptable: false)
  end

  def approved_application?
    pet_applications.any? do |record|
      record.approved == true
    end
  end
end
