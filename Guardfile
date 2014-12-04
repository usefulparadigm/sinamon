# More info at https://github.com/guard/guard#readme

# Guard::Compass
#
# You don't need to configure watchers for guard 'compass' declaration as they generated
# from your Compass configuration file. You might need to define the Compass working directory
# and point to the configuration file depending of your project structure.
#
# Available options:
#
# * :workging_directory => Define the Compass working directory, relative to the Guardfile directory
# * :configuration_file => Path to the Compass configuration file, relative to :project_path
#
# Like usual, the Compass configuration path are relative to the :project_path

guard :compass

guard :jammit do
  watch(%r{^app/scripts/(.*)\.js$})
  watch(%r{^public/css/(.*)\.css$})
end

guard 'livereload' do
  watch(%r{server/views/.+\.(erb|haml|slim)$})
  watch(%r{server/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  # watch(%r{config/locales/.+\.yml})
end

