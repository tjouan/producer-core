module FixturesHelpers
  FIXTURES_PATH = 'spec/fixtures'

  def fixture_path_for(path)
    File.join(FIXTURES_PATH, path)
  end
end
