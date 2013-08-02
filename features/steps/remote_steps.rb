Given /^a remote file named "([^"]+)"$/ do |file_name|
  write_file file_name, ''
end

Then /^the remote file "([^"]+)" should contain "([^"]+)"/ do |path, content|
  check_file_content path, content, true
end
