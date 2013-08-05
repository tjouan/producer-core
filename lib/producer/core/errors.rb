module Producer
  module Core
    Error                       = Class.new(StandardError)
    ConditionNotMetError        = Class.new(Error)
    RecipeEvaluationError       = Class.new(StandardError)
    TaskEvaluationError         = Class.new(RecipeEvaluationError)
    RemoteCommandExecutionError = Class.new(Error)
  end
end
