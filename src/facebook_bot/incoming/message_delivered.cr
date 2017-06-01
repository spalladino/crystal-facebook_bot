require "../identifiable"

class FacebookBot::Incoming::MessageDelivered
  class DeliveryContent
    JSON.mapping({
      mids:      Array(String),
      watermark: UInt64,
      seq:       UInt64,
    })
  end

  JSON.mapping({
    sender:    Identifiable,
    recipient: Identifiable,
    delivery:  DeliveryContent,
  })

  delegate mids, watermark, seq, to: delivery
end
