require 'rake'
require 'rake/testtask'



Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/tc_*.rb']
end

Rake.add_rakelib 'lib/tasks'

task default: :test

