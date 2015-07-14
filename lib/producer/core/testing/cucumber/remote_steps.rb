def stat_mode path
  cd '.' do
    ('%o' % [File::Stat.new(path).mode])[-4, 4]
  end
end

Given /^a remote directory named "([^"]+)"$/ do |path|
  create_directory path
end

Given /^a remote file named "([^"]+)"$/ do |file_name|
  write_file file_name, ''
end

Given /^a remote file named "([^"]+)" with "([^"]+)"$/ do |file_name, content|
  write_file file_name, content
end

Then /^the remote directory "([^"]+)" must exist$/ do |path|
  expect(path).to be_an_existing_directory
end

Then /^the remote file "([^"]+)" must exist$/ do |path|
  check_file_presence [path], true
end

Then /^the remote file "([^"]+)" must contain "([^"]+)"$/ do |path, content|
  expect(path).to have_file_content Regexp.new(content)
end

Then /^the remote file "([^"]+)" must contain exactly "([^"]+)"$/ do |path, content|
  expect(path).to have_file_content content
end

Then /^the remote file "([^"]+)" must contain exactly:$/ do |path, content|
  expect(path).to have_file_content content
end

Then /^the remote file "([^"]+)" must match \/([^\/]+)\/$/ do |path, pattern|
  expect(path).to have_file_content /#{pattern}/
end

Then /^the remote file "([^"]+)" must have (\d+) mode$/ do |path, mode|
  expect(stat_mode path).to eq mode
end

Then /^the remote directory "([^"]+)" must have (\d+) mode$/ do |path, mode|
  expect(stat_mode path).to eq mode
end
