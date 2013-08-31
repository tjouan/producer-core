# FIXME: our monkey patch currently prevent us from using `must' in step
# definitions.
Then(/^the output should contain my current login name$/) do
  assert_partial_output(Etc.getlogin, all_output)
end
