require 'twilio-ruby'

module RiverLevelSite
  module Messaging
    class Messenger
      def send(number, message)
        client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_AUTH"])
        message = client.messages.create(
          body: message,
          to: number,    # Replace with your phone number
          from: ENV["TWILIO_NUMBER"]
        )  # Replace with your Twilio number
      end

    end
  end
end