module Producer
  module Core
    Error                       = Class.new(StandardError)
    RuntimeError                = Class.new(RuntimeError)

    ArgumentError               = Class.new(Error)
    ConditionNotMetError        = Class.new(Error)
    RecipeEvaluationError       = Class.new(RuntimeError)
    RemoteCommandExecutionError = Class.new(RuntimeError)
    RegistryKeyError            = Class.new(RuntimeError)
    RemoteInvalidError          = Class.new(ArgumentError)
    TemplateMissingError        = Class.new(RuntimeError)
  end
end
