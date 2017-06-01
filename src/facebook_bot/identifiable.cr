class FacebookBot::Identifiable
  JSON.mapping({
    id: String,
  })

  def initialize(@id : String)
  end
end
