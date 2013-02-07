Generic.controllers :blocks do
  get :show, map: "/view/:id" do
    @block = Arena.block decode(params[:id])
    request.xhr? ? render("blocks/show", layout: false) : render("blocks/show")
  end
end
