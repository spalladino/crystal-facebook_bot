class FacebookBot::Outgoing::QuickReply
  JSON.mapping({
    content_type: String,
    title:        String,
    payload:      String,
  })

  getter title : String
  getter payload : String
  getter content_type : String

  def initialize(@title, payload = nil, content_type = "text")
    @payload = payload || @title
    @content_type = content_type
  end
end
