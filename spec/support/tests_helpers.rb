module TestsHelpers
  def test_ok
    double('test', success?: true)
  end

  def test_ko
    double('test', success?: false)
  end
end
