# encoding: UTF-8
if RUBY_VERSION < '1.9'
  def ruby_18
    yield
  end

  def ruby_19
    false
  end
else
  def ruby_18
    false
  end

  def ruby_19
    yield
  end
end
