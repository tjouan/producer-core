Then /^the output must contain my current login name$/ do
  assert_partial_output Etc.getlogin, all_output
end
