class FacebookBot::Outgoing::Message
  class MessageContent
    JSON.mapping({
      text:     String,
      metadata: String?,
    })

    def initialize(@text, @metadata = nil)
    end
  end

  JSON.mapping({
    recipient: Identifiable,
    message:   MessageContent,
  })

  delegate text, metadata, to: message

  def initialize(recipient_id, text, metadata = nil)
    @recipient = Identifiable.new(recipient_id)
    @message = MessageContent.new(text, metadata)
  end
end
