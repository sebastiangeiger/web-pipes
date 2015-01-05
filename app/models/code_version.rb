class CodeVersion < ActiveRecord::Base
  validates :job, presence: true
  validates :code, uniqueness: { scope: :job }
  belongs_to :job
end
