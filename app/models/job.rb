class Job < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :code_versions, -> { order(updated_at: :asc) }
  has_many :execution_results

  def code
    if latest_code_version
      latest_code_version.code
    else
      ''
    end
  end

  def code=(new_code)
    add_code_version(new_code) if code != new_code
  end

  private

  def add_code_version(new_code)
    code_versions << CodeVersion.new(job: self, code: new_code)
  end

  def latest_code_version
    code_versions.last
  end
end
