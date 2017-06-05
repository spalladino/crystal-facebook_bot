class FacebookBot::Incoming::Entry
  JSON.mapping({
    id:        String,
    time:      UInt64,
    messaging: Array(Message | MessageDelivered | Postback),
  })
end
