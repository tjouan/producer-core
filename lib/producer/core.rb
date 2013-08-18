# task actions
require 'producer/core/action'
require 'producer/core/actions/echo'
require 'producer/core/actions/shell_command'

# condition tests (need to be defined before the condition DSL)
require 'producer/core/test'

require 'producer/core/cli'
require 'producer/core/condition'
require 'producer/core/condition/dsl'
require 'producer/core/env'
require 'producer/core/errors'
require 'producer/core/interpreter'
require 'producer/core/recipe'
require 'producer/core/recipe/dsl'
require 'producer/core/remote'
require 'producer/core/remote/environment'
require 'producer/core/task'
require 'producer/core/task/dsl'
require 'producer/core/version'
