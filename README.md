producer
========

  Software provisioning and configuration management tool, providing a
DSL to write "recipes".

[![Version      ][badge-version-img]][badge-version-uri]
[![Build status ][badge-build-img]][badge-build-uri]
[![Code Climate ][badge-cclimate-img]][badge-cclimate-uri]


Getting started
---------------

### Installation (requires ruby ~> 2.1 and rubygems)

    $ gem install producer-core


### Simple recipe

  Recipes are composed by tasks and a task includes actions. Here we
use the `echo` action, which output the given string to standard
output. All the power of the Ruby language is available.

```ruby
hello_message = 'hello world!'

task :hello_world do
  echo hello_message
  echo hello_message.upcase
end
```

    $ producer simple_recipe.rb
    hello world!
    HELLO WORLD!


### Shell command execution on remote host

  The `sh` action will execute a shell command given as a string on
the targeted remote host. The remote host can be specified with the
CLI option `-t`.

```ruby
task :show_zsh_pkg do
  sh 'pkg info | grep zsh'
end
```

    $ producer -t localhost show_zsh_pkg.rb
    zsh-5.0.7                      The Z shell

  When execution fails, recipe processing is stopped and the action
which triggered the failed execution is the last one to be applied.

```ruby
task :sh_fail do
  sh 'false'
  echo 'end of recipe'
end
```

    $ producer -t localhost sh_fail.rb
    RemoteCommandExecutionError: false
    $

  Only the first action is applied.


### Task conditions

  A task can be bound to a condition: when the condition fails actions
are skipped, otherwise actions are applied as usual.

  This condition can be a simple ruby expression :

```ruby
task :condition_pass do
  condition { true }
  echo 'will output'
end

task :condition_fail do
  condition { false }
  echo 'will NOT output'
end
```

#### Built-in tests

  Specific test keywords are also available in the condition block
context, `producer-core` ships with a few common tests,
`producer-stdlib` provides more, and custom tests can be defined.

  Here we use the `sh` condition keyword which will pass when the
execution of the given shell command succeed, and fail when the
execution fails.

```ruby
task :condition_sh_pass do
  condition { sh 'true' }
  echo 'will output'
end

task :condition_sh_fail do
  condition { sh 'false' }
  cho 'will NOT output'
end
```


### Nested tasks

  Complex tasks can be split into nested subtasks. Conditions have
the same effect on tasks they have on actions, when the condition
fails, subtasks of the current task are skipped.

```ruby
task :main_task do
  condition { true }
  task(:foo_subtask) { echo 'do foo' }
  task(:bar_subtask) { echo 'do bar' }
  task(:baz_subtask) do
    condition { false }
    task(:baz_subtask_subtask) { echo 'do baz' }
  end
end
```
    $ producer nested_tasks.rb
    do foo
    do bar


Usage
-----

    Usage: producer [options] [recipes] [-- recipe_arguments...]
    
    options:
        -v, --verbose                    enable verbose mode
        -d, --debug                      enable debug mode
        -n, --dry-run                    enable dry run mode
        -t, --target HOST                target host


Actions
-------

See:
https://github.com/tjouan/producer-core/tree/master/features/actions


Tests
-----

See:
https://github.com/tjouan/producer-core/tree/master/features/tests


Templates
---------

  The following example can setup jails on a FreeBSD host.

  In `templates/freebsd/jail.conf.erb`:

```erb
exec.start = "/bin/sh /etc/rc";
exec.stop = "/bin/sh /etc/rc.shutdown";
exec.clean;
mount.devfs;
allow.chflags;

path = "/var/jails/$name";

<% @jails.each do |jail| -%>
<%= jail[:name] %> {
  interface "<%= @if %>";
  ip4.addr = <%= jail[:addr4] %>;
}
<% end -%>
```

Simple usage:

```ruby
INTERFACE   = 're0'.freeze
JAILS       = [{
  name:   'freebsd-10r1',
  src:    true,
  addr4:  '10.0.0.1'
}].freeze

task :jails_conf do
  conf = template 'freebsd/jail.conf', if: INTERFACE, jails: JAILS
  file_write_once '/etc/jail.conf', conf
end
```


Macros
------

FIXME


Test macros
-----------

FIXME


Macro composition
-----------------

FIXME


Background
----------

  producer started as a collection of heterogeneous scripts (Ruby,
POSIX shell, Perl…) in the late '90s. I wanted to experiment with the
design and usage of Domain Specific Languages in Ruby, and refactor
all my scripts as "recipes" in a common language.


Similar or related code and tools
---------------------------------

### Ruby DSL

* https://github.com/sprinkle-tool/sprinkle
* http://www.capistranorb.com/
* http://babushka.me/ (with BDD features, no network support?)

### Ruby DSL, shell script transpilation

* http://nadarei.co/mina/ (Rake based DSL, requires and uses bash)

### Ruby-like DSL

* http://puppetlabs.com/ (Ruby supported on >= 2.6.x)

### Agents, daemons

* https://github.com/saltstack/salt (Python, YAML)
* http://www.cobblerd.org/ (Python, many features)
* https://www.getchef.com/chef/

### SSH

* https://github.com/ansible/ansible (Python, YAML)
* http://docs.fabfile.org/ (Python)
* https://github.com/sebastien/cuisine (Python DSL, uses Fabric)
* https://github.com/kenn/sunzi (Ruby, provisioning, shell based)
* http://solutious.com/projects/rudy/ (Ruby, provisioning)

### Ruby SSH related code

* https://github.com/leehambley/sshkit
* https://github.com/gammons/screwcap
* https://github.com/delano/rye/
* https://github.com/jheiss/sshwrap

### BDD

* https://github.com/hedgehog/cuken (Cucumber)
* http://serverspec.org/ (RSpec, Net::SSH)
* https://github.com/auxesis/cucumber-nagios (Cucumber, Net::SSH,
  Webrat)
* http://larsyencken.github.io/marelle/ (Prolog, babushka inspired)



[badge-version-img]:  https://img.shields.io/gem/v/producer-core.svg?style=flat-square
[badge-version-uri]:  https://rubygems.org/gems/producer-core
[badge-build-img]:    https://img.shields.io/travis/tjouan/producer-core/master.svg?style=flat-square
[badge-build-uri]:    https://travis-ci.org/tjouan/producer-core
[badge-cclimate-img]: https://img.shields.io/codeclimate/github/tjouan/producer-core.svg?style=flat-square
[badge-cclimate-uri]: https://codeclimate.com/github/tjouan/producer-core
