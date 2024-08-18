require 'httpx/adapters/faraday'

class DiscordFaradayConnection
  include Singleton

  def get_connection
    @conn ||= Faraday.new("https://discord.com/", headers: { 'User-Agent' => "Faraday/2.10.1 mk2/0.1.0" }) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.response :raise_error
      faraday.response :logger
      faraday.adapter :httpx
    end
    @conn
  end
end

class SendToDiscordWebhookJob < ApplicationJob
  queue_as :default

  def perform(rawdata, sentfile, **options)
    options[:content] ||= ""
    options[:filetype] ||= "application/pdf"

    Tempfile.create(["attendance-", ".pdf"], mode: File::RDWR | File::CREAT | File::BINARY) do |file|
      file << rawdata
      file.rewind

      conn = DiscordFaradayConnection.instance.get_connection

      payload = {}
      payload[:file1] = Faraday::Multipart::FilePart.new(file, options[:filetype], sentfile)
      payload[:payload_json] = Faraday::Multipart::ParamPart.new(
        {
          content: options[:content],
        }.to_json,
        "application/json"
      )

      discord = Rails.application.credentials.discord!.webhook_token!
      conn.post("/api/webhooks/#{discord}", payload)
    end
  end
end
