module GetuiHelper
  
  extend self

  def base_url
    "https://restapi.getui.com/v1/#{APPID}/"
  end

  def auth_sign
    url = URI(base_url + 'auth_sign')
    timestamp = DateTime.now.strftime('%Q')
    str = [
      APPKEY,
      timestamp,
      MS
    ].join

    data = {
      sign: Digest::SHA256.new.hexdigest(str),
      timestamp: timestamp,
      appkey: APPKEY
    }.to_json
    header = {
      'Content-Type' => 'application/json'
    }
    r = JSON.parse(Net::HTTP.post(url, data, header).body)
    r['auth_token']
  end

  def push(cid, title, body, url)

    base.merge({
      push_info: push_info(title, body, url),
      cid: cid,
      requestid: SecureRandom.hex
    })

  end

  def base
    message = {
      appkey: APPKEY,
      is_offline: false,
      msgtype: 'transmission'
    }

    r = {
      message: message,
      transmission: transmission
    }
  end

  def transmission
    t = {
      transmission_content: '请填写透传内容'
    }
    r = { transmission: t }
  end

  def push_info(title, body, logo_url)
    p = {
      aps: {
        alert: {
          title: title,
          body: body
        },
        autoBadge: '+1',
        'content-available': 1
      },
      payload: 'payload',
      multimedia: [
        {
          url: logo_url,
          type: 1
        }
      ]
    }

    r = { push_info: p }
  end

end
