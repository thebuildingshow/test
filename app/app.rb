class Generic < Padrino::Application
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Assets
  
  enable :sessions

  configure do 
    set :haml, ugly: :true
  end
end
