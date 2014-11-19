require 'rake/testtask'
require 'jammit'

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

desc "jammit assets"
task :jammit do
  Jammit.package!
end
