require_relative './lib/controller_base'
require_relative './lib/router'
require_relative './lib/exceptions'
require_relative './lib/static_assets'

class Controller < ControllerBase
  def go
    if @req.path == "/cats"
      render_content("hello cats!", "text/html")
    elsif @req.path == "/fail"
      fail
    end
  end
end

# run Proc.new { |env|
#   req = Rack::Request.new(env)
#   res = Rack::Response.new
#   Controller.new(req, res).go
#   res.finish
# }

core_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  Controller.new(req, res).go
  res.finish
end

app = Rack::Builder.new do
  use Exceptions
  use StaticAssets
  run core_app
end.to_app

run app
