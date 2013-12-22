Given(/^a recipe with:$/) do |recipe_body|
  write_file 'recipe.rb', recipe_body
end

When(/^I execute the recipe$/) do
  run_simple('producer recipe.rb', false)
end

When(/^I successfully execute the recipe$/) do
  step 'I execute the recipe'
  assert_exit_status(0)
end

When(/^I execute the recipe interactively$/) do
  run_interactive('producer recipe.rb')
end
