class StaticAssets
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    asset_file = req.path[8..-1]
    if req.path.match(/^\/public/) && asset_file != ""
      @res = Rack::Response.new
      render(asset_file)
      @res.finish
    else
      app.call(env)
    end
  end

  def render(asset_file)
    file_path =
      "public/#{asset_file}"
    file_content = File.read(file_path)

    case asset_file.split(".").last
    when "css"
      render_content(file_content, "text/css")
    when "jpg"
      render_content(file_content, "image/jpeg")
    when "js"
      render_content(file_content, "application/javascript")
    end
  end

  def render_content(content, content_type)
    @res['Content-Type'] = content_type
    @res.write(content)
  end
end
