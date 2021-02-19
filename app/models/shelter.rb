class Shelter < ApplicationRecord
  has_many :pets

  def self pending
  pets.applications
  end
end
