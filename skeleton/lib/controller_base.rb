require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params)
    @req = req
    @res = res
    @params = route_params
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Double render error!"
    else
      @res.redirect(url)
      @already_built_response = true
      session.store_session(@res)
    end
    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Double render error!"
    else
      @res['Content-Type'] =  content_type
      @res.write(content)
      @already_built_response = true
      session.store_session(@res)
    end
    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    classname = self.class.to_s
    classname = classname.underscore
    file = File.read(File.expand_path("../../views/#{classname}/#{template_name}.html.erb", __FILE__))
    html = ERB.new(file).result(binding)
    render_content(html, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
  end
end
