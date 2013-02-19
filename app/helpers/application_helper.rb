App.helpers do
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

  def encoded_url(object, options={})
    return "/" if object.id == DEFAULT_CHANNEL_IDENTIFIER
    
    kind = object._base_class.downcase.pluralize.to_sym

    url_for(kind, :show, id: encode(object.id.to_s), next: options[:next], prev: options[:prev], via: options[:via])
  end

  def color_scheme
    ["normal", "inverse"].sample
  end
end
