class Job < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :code_versions
end
