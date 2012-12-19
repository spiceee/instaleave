class Instaleave < Sinatra::Base

  enable :sessions

  CALLBACK_URL = 'http://localhost:3001/redirect'
  MEDIA_DIR = './media/'

  Instagram.configure do |config|
    config.client_id = ''
    config.client_secret = ''
  end

  get "/" do
    '<a href="/connect">Connect with Instagram</a>'
  end

  get "/connect" do
    redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  get "/redirect" do
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    session[:access_token] = response.access_token
    redirect "/feed"
  end

  get "/feed" do
    client = Instagram.client(:access_token => session[:access_token])
    max_id = params[:max_id] || nil

    feed = client.user_recent_media({:count => 60, :max_id => max_id})
    max_id = feed['pagination']['next_max_id']

    html = '<h1>saving pics</h1>'

    unless max_id
      html << '<h2>... all done</h2>'
      return html
    end
    
    feed.data.each {|item| fetch_item(item) }
    
    html << "\n<script>location.replace('/feed?max_id=#{max_id}')</script>"
    html
  end
  
  def fetch_item(item)
    @http ||= HTTPClient.new
    url = item.images.standard_resolution.url
    puts "saving #{url}"
    basename = url.split('/').last
    response = @http.get(url)
    open(MEDIA_DIR + basename, 'wb') {|f| f << response.body }
  end

end