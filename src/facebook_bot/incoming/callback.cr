require "./entry"

class FacebookBot::Incoming::Callback
  JSON.mapping({
    object:  String,
    entries: {type: Array(Entry), key: "entry"},
  })

  def messaging(type : T.class) : Array({T, Entry}) forall T
    entries.flat_map do |entry|
      entry.messaging.select { |msg| msg.is_a?(T) }.map { |msg| {msg.as(T), entry} }
    end
  end
end
