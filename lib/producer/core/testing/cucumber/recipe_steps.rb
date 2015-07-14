def run_recipe remote: false, options: nil, check: false, rargv: nil
  command = %w[producer recipe.rb]
  case remote
  when :unknown then command += %w[-t unknown_host.test]
  when true     then command += %w[-t some_host.test]
  end
  command << options if options
  command << ['--', *rargv] if rargv

  with_env 'HOME' => File.expand_path(current_dir) do
    run_simple command.join(' '), false
  end

  assert_exit_status 0 if check
  assert_matching_output '\ASocketError', all_output if remote == :unknown
end

Given /^a recipe with:$/ do |recipe_body|
  write_file 'recipe.rb', recipe_body
end

Given /^a recipe with an error$/ do
  write_file 'recipe.rb', "fail 'some error'\n"
end

Given /^a recipe using a remote$/ do
  write_file 'recipe.rb', "task(:some_task) { sh 'echo hello' }\n"
end

Given /^a recipe named "([^"]+)" with:$/ do |recipe_path, recipe_body|
  write_file recipe_path, recipe_body
end

When /^I execute the recipe$/ do
  run_recipe
end

When /^I execute the recipe on remote target$/ do
  run_recipe remote: true
end

When /^I execute the recipe on unknown remote target$/ do
  run_recipe remote: :unknown
end

When /^I execute the recipe with options? (-.+)$/ do |options|
  run_recipe options: options
end

When /^I execute the recipe on unknown remote target with options? (-.+)$/ do |options|
  run_recipe remote: :unknown, options: options
end

When /^I successfully execute the recipe$/ do
  run_recipe check: true
end

When /^I successfully execute the recipe on remote target$/ do
  run_recipe remote: true, check: true
end

When /^I successfully execute the recipe on remote target with options? (-.+)$/ do |options|
  run_recipe remote: true, options: options, check: true
end

When /^I successfully execute the recipe with options? (-.+)$/ do |options|
  run_recipe options: options, check: true
end

When /^I successfully execute the recipe with arguments "([^"]+)"$/ do |rargv|
  run_recipe rargv: rargv, check: true
end

When /^I execute the recipe interactively$/ do
  run_interactive 'producer recipe.rb'
end
