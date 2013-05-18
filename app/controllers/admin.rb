App.controllers :admin do
  before do
    halt(401, "Not Authorized") unless authenticate_or_request_with_http_basic
  end

  get :index, map: "/admin" do
    render("admin/index")
  end

  post :encrypt, map: "/admin/encrypt" do
    @channel = Arena.channel(params[:id])
    redirect(encoded_url(@channel))
  end

  post :purge, map: "/admin/purge" do
    App.cache.flush
    redirect(url_for(:channels, :index))
  end
end
