require "logger"
require "../src/facebook_bot"

class EchoBot < FacebookBot::Bot
  def initialize(access_token, verify_token)
    super(access_token, verify_token, Logger.new(STDOUT))
  end

  def handle_message(message)
    logger.info("Received message #{message.text}")
    send_text(message.sender.id, message.text)
  end
end

access_token = ENV["ACCESS_TOKEN"]? || raise "Please set access token"
verify_token = ENV["VERIFY_TOKEN"]? || raise "Please set verify token"
bot = EchoBot.new(access_token, verify_token)
Signal::INT.trap { |x| puts "Closing"; bot.close }
bot.serve(bind_address: "0.0.0.0")
