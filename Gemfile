source "https://rubygems.org"


gem "sinatra"
gem "sinatra-contrib"
# gem "rack-cache"
gem "rack-parser"
gem "json"
gem "sinatra-static-assets"
# The minimum version of MongoDB is 2.2.0.
gem "mongoid", "~> 3.1.6"
gem "warden"
gem "bcrypt"
gem "static_model"
gem "erubis"
# gem "dotenv"

group :development do
  gem "thin"
  gem "racksh", :require => false
  gem "compass", :require => false
  # gem "modular-scale", :require => false

  # asset management
  gem "jammit"
  gem "sass"
  gem "coffee-script"

  # guards
  gem "guard-jammit"
  gem "guard-pow"
  gem "guard-compass"
end  

group :test do
  gem "minitest"
  gem "turn"
end
