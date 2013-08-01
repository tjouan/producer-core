require 'producer/core'

require 'support/exit_helpers'
require 'support/fixtures_helpers'


# Specific error thrown in the error fixture recipe, we can't define it in the
# recipe, rspec wouldn't know about it.
SomeErrorInRecipe = Class.new(RuntimeError)
