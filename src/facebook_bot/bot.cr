require "http/server"

module FacebookBot
  abstract class Bot
    include FacebookBot::SendMessage
    include FacebookBot::GetUser

    getter access_token
    getter verify_token
    getter logger

    @server : HTTP::Server?

    def initialize(@access_token : String, @verify_token : String, @logger : Logger)
    end

    abstract def handle_message(message, entry)

    def handle_postback(postback, entry)
    end

    def serve(bind_address : String = "127.0.0.1", bind_port : Int32 = 80, ssl_certificate_path : String | Nil = nil, ssl_key_path : String | Nil = nil)
      server = HTTP::Server.new(bind_address, bind_port, [ReceiveHandler.new(self, @logger), VerificationHandler.new(@verify_token, @logger)])
      if ssl_certificate_path && ssl_key_path
        ssl = OpenSSL::SSL::Context::Server.new
        ssl.certificate_chain = ssl_certificate_path.not_nil!
        ssl.private_key = ssl_key_path.not_nil!
        server.tls = ssl
      end

      logger.info("Listening for Facebook requests in #{bind_address}:#{bind_port}#{" with tls" if server.tls}")
      @server = server
      server.listen
    end

    def close
      if server = @server
        server.close
      end
    end
  end
end
