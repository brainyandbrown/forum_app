module ForumApp
  class Server < Sinatra::Base

    enable :logging, :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get'/' do
    query_string = URI.encode_www_form({
      :client_id     => "395320660636532",
      :scope         => "",
      :redirect_uri  => "http://localhost:9292/facebook/topics"
    })
    @facebook_auth_url = "https://www.facebook.com/dialog/oauth?" + query_string

    render :erb, :index
  end

  get'/facebook/topics' do
    # binding.pry
    query_string = URI.encode_www_form({
      :client_id     => "395320660636532",
      :redirect_uri  => "http://localhost:9292/facebook/topics",
      :client_secret => "2bd77564e95c7ae5c546268ab2c23811",
      :code          => params["code"]
    })
    response = HTTParty.get("https://graph.facebook.com/oauth/access_token?" + query_string,
      :headers => {
        "Accept" => "application/json"
      })
     # binding.pry

    response_hash = Rack::Utils.parse_query(response)
    render :erb, :topics
  end

  get '/facebook/topics/new' do
    topic =
    render :erb, :new
  end

  get('/facebook/logout') do
      session[:name] = session[:access_token] = nil # dual assignment!
      redirect to("/")
    end


  end
end
