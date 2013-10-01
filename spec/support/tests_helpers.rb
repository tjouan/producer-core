module TestsHelpers
  def test_ok
    double('test', pass?: true)
  end

  def test_ko
    double('test', pass?: false)
  end
end
