require 'warden'

Warden::Manager.serialize_into_session { |user| user.id }
Warden::Manager.serialize_from_session { |id| User.find(id) }

Warden::Strategies.add(:password) do
  def valid?
    params["email"] || params["password"]
  end

  # def username
  #   params['email'] || params['login']
  # end
 
  def authenticate!
    user = User.where(email: params["email"]).first
    if user && user.authenticate(params["password"])
      success!(user)
    else
      fail!("Could not log in")
    end    
  end
end

Warden::Strategies.add(:facebook) do
  def authenticate!
    auth_hash = env['omniauth.auth'] # => OmniAuth::AuthHash
    user = User.find_or_create_by(uid: auth_hash['uid']) do |u|
      u.email = auth_hash['info']['email']
      u.name = auth_hash['info']['name']
      u.nickname = auth_hash['info']['nickname']
    end
    success!(user)
  rescue
    fail!("Could not log in")
  end
end
