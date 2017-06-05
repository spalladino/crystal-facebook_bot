require "http/server/handler"

module FacebookBot
  class ReceiveHandler
    include HTTP::Handler

    def initialize(@bot : Bot, @logger : Logger)
    end

    def call(context : HTTP::Server::Context)
      if context.request.method == "POST"
        callback = FacebookBot::Incoming::Callback.from_json(context.request.body.not_nil!)
        callback.messaging(FacebookBot::Incoming::Message).each do |(msg, entry)|
          spawn { @bot.handle_message(msg, entry) }
        end
        callback.messaging(FacebookBot::Incoming::Postback).each do |(msg, entry)|
          spawn { @bot.handle_postback(msg, entry) }
        end
        context.response.status_code = 200
        context.response.puts("OK")
      else
        call_next(context)
      end
    end
  end
end
