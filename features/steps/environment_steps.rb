Given /^I set the environment variable "([^"]+)"$/ do |variable|
  set_environment_variable variable, 'yes'
end
