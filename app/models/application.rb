class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  validates_presence_of :name, :street, :city, :state, :zip

  def has_pets?
    pets.any?
  end

  def in_progress?
    status == "In Progress"
  end

  def ready_to_submit?
    has_pets? && in_progress?
  end

  def submitted?
    status == "Pending"
  end
end
