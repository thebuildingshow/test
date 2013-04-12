App.helpers do
  def authenticate_or_request_with_http_basic(realm="Application")
    authenticate_with_http_basic || request_http_basic_authentication(realm)
  end

  def authenticate_with_http_basic
    if auth_str = request.env["HTTP_AUTHORIZATION"]
      ENV["USERNAME_PASSWORD"] == Base64.decode64(auth_str.sub(/^Basic\s+/, ""))
    end
  end

  def request_http_basic_authentication(realm="Application")
    response.headers["WWW-Authenticate"] = %(Basic realm="Application")
    response.body = "HTTP Basic: Access denied.\n"
    response.status = 401
    
    false
  end
  
  def encrypt_value(val)
    Encryptor.encrypt(val, key: KEY)
  end
  
  def decrypt_value(val)
    Encryptor.decrypt(val, key: KEY)
  end

  def encode(id)
    Base64.urlsafe_encode64(encrypt_value(id))
  end

  def decode(id)
    decrypt_value(Base64.urlsafe_decode64(id))
  end

  def return_url(via=nil)
    return "/" if (via.nil? || via == DEFAULT_CHANNEL_IDENTIFIER[:slug])

    encoded = encode(via)

    url_for(:channels, :show, id: encoded)
  end

  def encoded_url(object, options={})
    return "/" if object.id == DEFAULT_CHANNEL_IDENTIFIER[:id]
    
    kind = object._base_class.downcase.pluralize.to_sym

    url_for(kind, :show, id: encode(object.id.to_s), next: options[:next], prev: options[:prev], via: options[:via])
  end

  def color_scheme
    ["normal", "inverse"].sample
  end
end
