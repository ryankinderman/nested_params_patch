require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList["#{File.dirname(__FILE__)}/test/*_test.rb"]
  t.verbose = true
end

task :default => [:test]