Given /^a remote directory named "([^"]+)"$/ do |path|
  create_dir path
end

Given /^a remote file named "([^"]+)"$/ do |file_name|
  write_file file_name, ''
end

Given /^a remote file named "([^"]+)" with "([^"]+)"$/ do |file_name, content|
  write_file file_name, content
end

Then /^the remote directory "([^"]+)" must exists$/ do |path|
  check_directory_presence [path], true
end

Then /^the remote file "([^"]+)" must contain "([^"]+)"$/ do |path, content|
  check_file_content path, content, true
end

Then /^the remote file "([^"]+)" must contain exactly "([^"]+)"$/ do |path, content|
  check_exact_file_content path, content
end

Then /^the remote file "([^"]+)" must have (\d+) mode$/ do |path, mode|
  in_current_dir do
    puts path, ('%o' % [File::Stat.new(path).mode])[-4, 4], mode
    expect(('%o' % [File::Stat.new(path).mode])[-4, 4]).to match mode
  end
end
