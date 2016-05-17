class StaticAssets
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    file_name = req.path[8..-1]

    if req.path.index("/public")
      res = build_response(file_name)
    else
      res = @app.call(env)
    end

    res
  end

  private

  def build_response(file_name)
    res = Rack::Response.new

    case File.extname(file_name)
    when ".css"
      content_type = "text/css"
    when ".jpg"
      content_type = "image/jpeg"
    when ".js"
      content_type = "application/javascript"
    end

    res["Content-type"] = content_type
    res.write(File.read("public/#{file_name}"))

    res
  end
end
