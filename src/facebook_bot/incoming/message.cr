require "../identifiable"

class FacebookBot::Incoming::Message
  class MessageContent
    JSON.mapping({
      mid:  String,
      text: String,
    })
  end

  JSON.mapping({
    sender:    Identifiable,
    recipient: Identifiable,
    timestamp: UInt64,
    message:   MessageContent,
  })

  delegate mid, text, to: message
end
