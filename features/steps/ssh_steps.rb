Given /^an SSH config with:$/ do |config|
  write_file '.ssh/config', config
end
