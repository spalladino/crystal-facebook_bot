require "http/server/handler"

module FacebookBot
  class VerificationHandler
    include HTTP::Handler

    def initialize(@verify_token : String, @logger : Logger)
    end

    def call(context : HTTP::Server::Context)
      if context.request.method == "GET" && context.request.query_params["hub.mode"]? == "subscribe"
        if context.request.query_params["hub.verify_token"] == @verify_token
          @logger.info("Verified endpoint")
          context.response.status_code = 200
          context.response.puts(context.request.query_params["hub.challenge"])
        else
          @logger.warn("Invalid token for endpoint verification")
          context.response.status_code = 403
          context.response.puts("Invalid token")
        end
      else
        call_next(context)
      end
    end
  end
end
