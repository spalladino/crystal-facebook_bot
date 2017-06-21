require "logger"
require "../src/facebook_bot"

class EchoBot < FacebookBot::Bot
  def initialize(access_token, verify_token)
    super(access_token, verify_token, Logger.new(STDOUT))
  end

  def handle_message(message, entry)
    logger.info("Received message #{message.text}")
    user = user_profile!(message.sender.id)
    send_text_with_quick_replies(message.sender.id, "Hello #{user.first_name} #{user.last_name}!\n\n#{message.text}", ["Yes", "No", "Maybe"])
  end
end

access_token = ENV["ACCESS_TOKEN"]? || raise "Please set access token"
verify_token = ENV["VERIFY_TOKEN"]? || raise "Please set verify token"
bot = EchoBot.new(access_token, verify_token)
Signal::INT.trap { |x| puts "Closing"; bot.close }
bot.serve(bind_address: "0.0.0.0")
