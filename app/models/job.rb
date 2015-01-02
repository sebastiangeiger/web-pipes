class Job < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :code_versions, -> { order(updated_at: :asc) }

  def code
    if latest_code_version
      latest_code_version.code
    else
      ''
    end
  end

  def code=(new_code)
    CodeVersion.create(job: self, code: new_code)
  end

  def latest_code_version
    code_versions.last
  end
end
