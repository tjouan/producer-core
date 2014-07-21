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
