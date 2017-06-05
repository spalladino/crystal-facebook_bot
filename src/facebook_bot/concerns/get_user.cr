require "http/client"

module FacebookBot::GetUser
  abstract def access_token : String
  abstract def logger : Logger

  FIELDS = %w(first_name last_name profile_pic locale timezone gender)

  def user_profile(user_id, fields = FIELDS, token = nil)
    url = "https://graph.facebook.com/v2.6/#{user_id}?access_token=#{token || access_token}&fields=#{fields.join(",")}"
    response = HTTP::Client.get(url, HTTP::Headers{"Content-Type" => "application/json"})
    if !response.success?
      logger.warn("Unsuccessful retrieving user profile for #{user_id}: #{response.status_message} #{response.status_code}\n#{response.body.try(&.to_s)}")
      return nil
    else
      FacebookBot::UserProfile.from_json(response.body)
    end
  rescue err
    logger.warn("Error sending text message to #{user_id}: #{err.message}")
    return nil
  end

  def user_profile!(user_id, fields = FIELDS)
    user_profile(user_id, fields).not_nil!
  end
end
