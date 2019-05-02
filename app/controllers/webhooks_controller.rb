class WebhooksController < ApplicationController
  include FrtCheck

  def hook
    icom = Intercom::Client.new(token: Rails.application.secrets.icom_token)
    # icom = Intercom::Client.new(token: Rails.application.secrets.sb_token)
    
    vip_inbox = 2001586 #for sb_token testing
    cse_inbox = 534597 #for CSE in prod
    
    red_kpi = 120.minutes.ago.to_i
    
    slack_post = 'https://slack.com/api/chat.postMessage'
    message_payload = {
      "token": "#{Rails.application.secrets.borkBot_oauth}",
      "channel": "#cse-kpi-alerts"
    }

    dd_api_key = Rails.application.secrets.dd_api_key
    dd_app_key = Rails.application.secrets.dd_app_key

    datadog_resolve = "https://app.datadoghq.com/monitor/bulk_resolve?api_key=#{dd_api_key}&application_key=#{dd_app_key}"
    headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
    cse_monitor = {"resolve": [{"8755429": "*"}]}

    if title_contains?("Warn") #amber
      message_payload["text"] = "It Ambork"
      res = HTTParty.post(slack_post, body: message_payload)
      
    elsif title_contains?("Triggered") #red
      reds = over_limit_count(cse_inbox, red_kpi, icom)

      if reds > 0 
        message_payload["text"] = " Oh no it red!! #{reds} over KPI"
        
        HTTParty.post(slack_post, body: message_payload) 
        HTTParty.post(datadog_resolve, :body => cse_monitor.to_json, :headers => headers)
      else
        message_payload["text"] = "We good - Red count is #{reds}"
        
        HTTParty.post(slack_post, body: message_payload)
        HTTParty.post(datadog_resolve, :body => cse_monitor.to_json, :headers => headers)
      end

    elsif title_contains?("Recovered") #resolved
      # recovery message?
    end
  end
  
  private
    def title_contains?(word)
      params["title"].scan(word).length > 0
    end
end
