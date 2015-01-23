class ExecutionResult < ActiveRecord::Base
  validates :job, presence: true

  serialize :messages, Array

  belongs_to :job
end
