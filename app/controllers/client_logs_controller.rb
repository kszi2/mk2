class ClientLogsController < ApplicationController
  def log
    @status = "ok"
    case params[:type]
    in "error" | "warn" | "info"
      Rails.logger.send(params[:type], "client-side log: " + (params[:message].to_s || "<body missing>"))
      if params[:message].empty?
        Rails.logger.error("client-side logs contained empty message")
        @status = "empty message"
      end
    else
      @status = "invalid type: '#{params[:type]}'"
    end
  end
end
