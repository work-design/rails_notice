module GetuiHelper
  APPID = 'X1HEFkU8ID6p59ycdbql91'
  APPKEY = 'NxWOzrhZ6j7O2AvE7w1Dq3'
  extend self

  def base_url
    "https://restapi.getui.com/v1/#{APPID}/"
  end

  def sign(string)
    digest = OpenSSL::Digest::SHA256.new
    pkey = OpenSSL::PKey::RSA.new(APPKEY)
    signature = pkey.sign(digest, string)

    Base64.strict_encode64(signature)
  end

  def auth_sign
    url = base_url + 'auth_sign'


  end



end
