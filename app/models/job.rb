class Job < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :code_versions

  def code
    if latest_code_version
      latest_code_version.code
    else
      ''
    end
  end

  def latest_code_version
    code_versions.last
  end
end
