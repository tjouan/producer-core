require 'cucumber/rake/task'
require 'rspec/core/rake_task'

task default: %i[features spec]

Cucumber::Rake::Task.new :features do |t|
  if ENV.key? 'TRAVIS'
    t.profile       = 'quiet'
    t.cucumber_opts = '--tags ~@ci_skip'
  end
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--format progress' if ENV.key? 'TRAVIS'
end
