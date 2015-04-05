require File.expand_path('../lib/producer/core/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = 'producer-core'
  s.version = Producer::Core::VERSION.dup
  s.summary = 'Provisioning tool'
  s.description = <<-eoh.gsub(/^ +/, '')
    Software provisioning tool, including a DSL to write "recipes".
  eoh
  s.homepage = 'https://rubygems.org/gems/producer-core'

  s.authors = 'Thibault Jouan'
  s.email   = 'tj@a13.fr'

  s.files       = `git ls-files`.split $/
  s.test_files  = s.files.grep /\A(spec|features)\//
  s.executables = s.files.grep(/\Abin\//) { |f| File.basename(f) }


  s.add_dependency 'net-ssh',   '~> 2.7'
  s.add_dependency 'net-sftp',  '~> 2.1'

  s.add_development_dependency 'rspec',         '~> 3.1'
  s.add_development_dependency 'cucumber',      '~> 2.0'
  s.add_development_dependency 'aruba',         '~> 0.5'
  s.add_development_dependency 'cucumber-sshd', '~> 1.0'
  s.add_development_dependency 'rake',          '~> 10.1'
end
