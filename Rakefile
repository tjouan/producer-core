require 'cucumber/rake/task'
require 'rspec/core/rake_task'

desc 'Run all scenarios'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = '--tags ~@sshd'
end

desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec)


task default: [:features, :spec]
