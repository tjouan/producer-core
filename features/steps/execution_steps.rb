Then /^the exit status must be (\d+)$/ do |exit_status|
  assert_exit_status exit_status.to_i
end
