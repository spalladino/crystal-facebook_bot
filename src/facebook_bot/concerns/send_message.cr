require "http/client"

module FacebookBot::SendMessage
  abstract def access_token : String
  abstract def logger : Logger

  def send_text(recipient_id, text, metadata = nil, token = nil)
    message = FacebookBot::Outgoing::Message.new(recipient_id, text, metadata)
    send_message(recipient_id, message, metadata, token)
  end

  def send_text_with_quick_replies(recipient_id, text, options, metadata = nil, token = nil)
    quick_replies = options.map { |text| FacebookBot::Outgoing::QuickReply.new(text) }
    message = FacebookBot::Outgoing::Message.new(recipient_id, text, metadata, quick_replies)
    send_message(recipient_id, message, metadata, token)
  end

  def send_message(recipient_id, message, metadata = nil, token = nil)
    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{token || access_token}"
    response = HTTP::Client.post(url, HTTP::Headers{"Content-Type" => "application/json"}, message.to_json)
    if !response.success?
      logger.warn("Unsuccessful sending text message to #{recipient_id}: #{response.status_message} #{response.status_code}\n#{response.body.try(&.to_s)}")
    end
  rescue err
    logger.warn("Error sending text message to #{recipient_id}: #{err.message}")
  end
end
