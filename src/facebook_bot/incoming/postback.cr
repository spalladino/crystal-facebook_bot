require "../identifiable"

class FacebookBot::Incoming::Postback
  class PostbackContent
    class Referral
      JSON.mapping({
        source: String,
        type:   String,
        ref:    String?,
        ad_id:  String?,
      })
    end

    JSON.mapping({
      payload:  String,
      referral: Referral?,
    })
  end

  JSON.mapping({
    sender:    Identifiable,
    recipient: Identifiable,
    timestamp: UInt64,
    postback:  PostbackContent,
  })

  delegate payload, referral, to: postback
end
