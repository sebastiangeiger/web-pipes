class User < ActiveRecord::Base
  validates :username, presence: true
  validates :full_name, presence: true
  validates :provider_uid, presence: true, uniqueness: true
end
