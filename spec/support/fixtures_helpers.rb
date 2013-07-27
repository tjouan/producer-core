module FixturesHelpers
  FIXTURE_PATH = File.join(File.dirname(__FILE__), '..', 'fixtures')

  def fixture_path_for(path)
    File.join(FIXTURE_PATH, path)
  end
end
