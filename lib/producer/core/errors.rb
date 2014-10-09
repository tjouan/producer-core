module Producer
  module Core
    Error                       = Class.new(StandardError)
    RuntimeError                = Class.new(RuntimeError)
    ArgumentError               = Class.new(Error)
    ConditionNotMetError        = Class.new(Error)
    RemoteCommandExecutionError = Class.new(RuntimeError)
    RegistryKeyError            = Class.new(RuntimeError)
  end
end
