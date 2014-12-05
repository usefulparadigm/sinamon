require 'mongoid'
require 'bcrypt'

class User
  include Mongoid::Document
  include BCrypt
  
  # field :username, type: String
  field :email, type: String
  field :password_hash, type: String
  
  def password
    @password ||= Password.new(password_hash)
  end
  
  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(attempted_password)
    self.password == attempted_password
  end

end