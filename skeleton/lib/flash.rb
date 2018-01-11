require 'json'

class Flash
  def initialize
    @flash = {}
  end

  def [](key)
    @flash[key]
  end

  def []=(key, value)
    @flash[key] = value
  end
end
