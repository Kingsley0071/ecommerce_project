require 'twilio-ruby'

class TwilioService
  def self.send_sms(to:, body:)
    client = Twilio::REST::Client.new(
      TwilioConfig[:account_sid],
      TwilioConfig[:auth_token]
    )
    client.messages.create(
      from: TwilioConfig[:phone_number],
      to: to,
      body: body
    )
  end
end