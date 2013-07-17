lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH << lib unless $LOAD_PATH.include? lib
require 'producer/core/version'

Gem::Specification.new do |s|
  s.name    = 'producer-core'
  s.version = Producer::Core::VERSION
  s.summary = "producer-core-#{Producer::Core::VERSION}"
  s.description = <<-eoh.gsub(/^ +/, '')
    blah
  eoh
  s.homepage = 'https://rubygems.org/gems/producer-core'

  s.authors = 'Thibault Jouan'
  s.email   = 'tj@a13.fr'

  s.files       = `git ls-files`.split $/
  s.test_files  = s.files.grep /\A(spec|features)\//
  s.executables = s.files.grep(/\Abin\//) { |f| File.basename(f) }
end
