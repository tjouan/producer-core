module Producer
  module Core
    Error                       = Class.new(StandardError)
    ConditionNotMetError        = Class.new(Error)
    RemoteCommandExecutionError = Class.new(Error)
  end
end
