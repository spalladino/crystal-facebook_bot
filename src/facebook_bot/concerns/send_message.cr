require "http/client"

module FacebookBot::SendMessage
  abstract def access_token : String
  abstract def logger : Logger

  def send_text(recipient_id, text, metadata = nil)
    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{access_token}"
    message = FacebookBot::Outgoing::Message.new(recipient_id, text, metadata)
    response = HTTP::Client.post(url, HTTP::Headers{"Content-Type" => "application/json"}, message.to_json)
    if !response.success?
      logger.warn("Unsuccessful sending text message to #{recipient_id}: #{response.status_message} #{response.status_code}\n#{response.body.try(&.to_s)}")
    end
  rescue err
    logger.warn("Error sending text message to #{recipient_id}: #{err.message}")
  end
end
