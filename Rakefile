require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task default: %i[features spec]

Cucumber::Rake::Task.new(:features)

Cucumber::Rake::Task.new(:features_ci) do |t|
  t.instance_eval { @desc << ' excluding @ci_skip' }
  t.cucumber_opts = '--tags ~@ci_skip'
  t.profile = 'quiet' if ENV.key? 'TRAVIS'
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--format progress' if ENV.key? 'TRAVIS'
end

desc 'Run CI test suite'
task ci: %i[features_ci spec]
