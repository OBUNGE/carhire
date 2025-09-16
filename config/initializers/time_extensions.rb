# config/initializers/time_extensions.rb
class Numeric
  # Convert seconds to milliseconds
  def in_milliseconds
    self * 1000
  end
end
