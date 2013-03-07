class App < Padrino::Application
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Assets
  register Padrino::Cache
  
  enable :sessions

  disable :raise_errors
  disable :show_exceptions

  configure :development do
    enable :raise_errors
    enable :show_exceptions
  end

  configure do 
    set :haml, ugly: :true
  end

  error 400..510 do
    status 404
    render("errors/generic")
  end
end
