Given(/^a recipe with:$/) do |recipe_body|
  write_file 'recipe.rb', recipe_body
end

When(/^I execute the recipe$/) do
  run_simple('producer localhost recipe.rb', false)
end
