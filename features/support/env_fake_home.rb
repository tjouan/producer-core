Before('@fake_home') do
  ENV['HOME'] = File.expand_path(current_dir)
end
