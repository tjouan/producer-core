Given /^a remote directory named "([^"]+)"$/ do |path|
  create_dir path
end

Given /^a remote file named "([^"]+)"$/ do |file_name|
  write_file file_name, ''
end

Given /^a remote file named "([^"]+)" with "([^"]+)"$/ do |file_name, content|
  write_file file_name, content
end

Then /^the remote directory "([^"]+)" should exists$/ do |path|
  check_directory_presence([path], true)
end

Then /^the remote file "([^"]+)" should contain "([^"]+)"/ do |path, content|
  check_file_content path, content, true
end
