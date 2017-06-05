class FacebookBot::UserProfile
  JSON.mapping({
    first_name:  String?,
    last_name:   String?,
    gender:      String?,
    timezone:    Int32?,
    locale:      String?,
    profile_pic: String?,
  })
end
