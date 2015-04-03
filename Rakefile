require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task default: %i[features spec]

Cucumber::Rake::Task.new(:features)

Cucumber::Rake::Task.new(:features_no_sshd) do |t|
  t.instance_eval { @desc << ' excluding @sshd'}
  t.cucumber_opts = '--tags ~@sshd'
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run CI test suite'
task ci: %i[features_no_sshd spec]
