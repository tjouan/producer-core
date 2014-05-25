module Producer
  module Core
    Error                       = Class.new(StandardError)
    RuntimeError                = Class.new(RuntimeError)
    ConditionNotMetError        = Class.new(Error)
    RemoteCommandExecutionError = Class.new(RuntimeError)
  end
end
