# FIXME: current home directory shouldn't be changed here, maybe we should use
# a tag for features needing a fake home directory.
Given /^an SSH config with:$/ do |config|
  ENV['HOME'] = File.expand_path(current_dir)
  write_file '.ssh/config', config
end
