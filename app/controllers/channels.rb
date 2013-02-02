Generic.controllers :channels do

  get :index, map: "/" do
    @channel = Arena.channel DEFAULT_CHANNEL_IDENTIFIER
    render "channels/show"
  end

  get :show, map: "/:id" do
    @channel = Arena.channel decode(params[:id])
    request.xhr? ? render("channels/show", layout: false) : render("channels/show")
  end

end