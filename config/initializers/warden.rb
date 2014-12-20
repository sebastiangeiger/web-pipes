Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :openid
  manager.failure_app = lambda do |env|
    SessionsController.action(:failure).call(env)
  end
end

Warden::Manager.serialize_into_session(&:id)

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:openid) do
  def authenticate!
    if auth_hash_valid?
      success! find_or_create_user
    else
      fail 'Auth hash was not valid'
    end
  end

  private

  def find_or_create_user
    user = User.find_by(provider_uid: provider_uid)
    unless user.present?
      user = User.create(full_name: full_name,
                         provider_uid: provider_uid,
                         username: username)
    end
    user
  end

  def auth_hash_valid?
    auth_hash.present? &&
      auth_hash.uid.present? &&
      auth_hash.provider == 'github'
  end

  def provider_uid
    "#{auth_hash.provider}_#{auth_hash.uid}"
  end

  def full_name
    auth_hash.info.name
  end

  def username
    auth_hash.info.nickname
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
