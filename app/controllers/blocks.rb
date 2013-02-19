App.controllers :blocks do
  get :show, map: "/view/:id" do
    @block = CachedArena.block decode(params[:id])
    request.xhr? ? render("blocks/show", layout: false) : render("blocks/show")
  end
end
