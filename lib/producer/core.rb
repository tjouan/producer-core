require 'etc'
require 'forwardable'
require 'optparse'
require 'pathname'

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

# condition tests
require 'producer/core/test'
require 'producer/core/tests/condition_test'
require 'producer/core/tests/file_contains'
require 'producer/core/tests/file_eq'
require 'producer/core/tests/has_dir'
require 'producer/core/tests/has_env'
require 'producer/core/tests/has_executable'
require 'producer/core/tests/has_file'
require 'producer/core/tests/shell_command_status'

require 'producer/core/cli'
require 'producer/core/condition'
require 'producer/core/env'
require 'producer/core/errors'
require 'producer/core/logger_formatter'
require 'producer/core/prompter'
require 'producer/core/recipe'
require 'producer/core/recipe/file_evaluator'
require 'producer/core/remote'
require 'producer/core/remote/environment'
require 'producer/core/remote/fs'
require 'producer/core/task'
require 'producer/core/version'
require 'producer/core/worker'
