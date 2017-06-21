require "./quick_reply"

class FacebookBot::Outgoing::Message
  class MessageContent
    JSON.mapping({
      text:          String,
      quick_replies: Array(QuickReply)?,
      metadata:      String?,
    })

    def initialize(@text, @metadata = nil, @quick_replies = nil)
    end
  end

  JSON.mapping({
    recipient: Identifiable,
    message:   MessageContent,
  })

  delegate text, metadata, quick_replies, to: message

  def initialize(recipient_id, text, metadata = nil, quick_replies = nil)
    @recipient = Identifiable.new(recipient_id)
    @message = MessageContent.new(text, metadata, quick_replies)
  end
end
