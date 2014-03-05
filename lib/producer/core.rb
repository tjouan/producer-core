require 'forwardable'

require 'etc'
require 'net/ssh'
require 'net/sftp'


# task actions
require 'producer/core/action'
require 'producer/core/actions/echo'
require 'producer/core/actions/shell_command'
require 'producer/core/actions/mkdir'
require 'producer/core/actions/file_append'
require 'producer/core/actions/file_replace_content'
require 'producer/core/actions/file_writer'

# condition tests (need to be defined before the condition DSL)
require 'producer/core/test'
require 'producer/core/tests/file_contains'
require 'producer/core/tests/has_dir'
require 'producer/core/tests/has_env'
require 'producer/core/tests/has_file'

require 'producer/core/cli'
require 'producer/core/condition'
require 'producer/core/condition/dsl'
require 'producer/core/env'
require 'producer/core/errors'
require 'producer/core/prompter'
require 'producer/core/recipe'
require 'producer/core/recipe/dsl'
require 'producer/core/remote'
require 'producer/core/remote/environment'
require 'producer/core/remote/fs'
require 'producer/core/task'
require 'producer/core/task/dsl'
require 'producer/core/version'
require 'producer/core/worker'
