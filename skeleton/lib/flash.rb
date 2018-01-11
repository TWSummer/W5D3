require 'json'

class Flash
  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    if cookie
      @flashnow = JSON.parse(cookie)
      @flash = {}
    else
      @flashnow = {}
      @flash = {}
    end
  end

  def [](key)
    @flash.merge(@flashnow)[key.to_s]
  end

  def []=(key, value)
    @flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie("_rails_lite_app_flash", JSON.generate(@flash))
  end

  def now
    @flashnow
  end
end
