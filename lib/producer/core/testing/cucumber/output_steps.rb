Then /^the output must contain exactly the usage$/ do
  assert_exact_output <<-eoh, all_output
Usage: producer [options] [recipes]

options:
    -v, --verbose                    enable verbose mode
    -d, --debug                      enable debug mode
    -n, --dry-run                    enable dry run mode
    -t, --target HOST                target host
  eoh
end

Then /^the output must match \/([^\/]+)\/$/ do |pattern|
  assert_matching_output pattern, all_output
end

Then /^the output must contain "([^"]+)"$/ do |content|
  assert_partial_output content, all_output
end

Then /^the output must contain:$/ do |content|
  assert_partial_output content, all_output
end

Then /^the output must not contain "([^"]+)"$/ do |content|
  assert_no_partial_output content, all_output
end

Then /^the output must contain exactly "([^"]+)"$/ do |content|
  assert_exact_output content, all_output
end

Then /^the output must contain exactly:$/ do |content|
  assert_exact_output content, all_output
end

Then /^the error output must contain exactly "([^"]+)"$/ do |content|
  assert_exact_output content, all_stderr
end

Then /^the output must contain ruby lib directory$/ do
  assert_partial_output RbConfig::CONFIG['rubylibdir'], all_output
end

Then /^the output must not contain ruby lib directory$/ do
  assert_no_partial_output RbConfig::CONFIG['rubylibdir'], all_output
end
