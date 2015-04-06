Given /^I set the environment variable "([^"]+)"$/ do |variable|
  set_env variable, 'yes'
end
