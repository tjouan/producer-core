Given(/^a remote file named "(.*?)"$/) do |file_name|
  write_file file_name, ''
end
