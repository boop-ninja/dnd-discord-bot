require 'rake'
require 'rake/testtask'



Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/tc_*.rb']
end

Rake.add_rakelib 'lib/tasks'

task default: :test

desc "Build the project in docker"
task :build do
  exec("docker build . --tag mbround18/dnd-discord-bot:latest")
end

desc "Publish to docker hub"
task :publish do
  exec("docker push mbround18/dnd-discord-bot:latest")
end