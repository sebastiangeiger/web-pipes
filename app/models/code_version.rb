class CodeVersion < ActiveRecord::Base
  validates :job, presence: true
  belongs_to :job
end
