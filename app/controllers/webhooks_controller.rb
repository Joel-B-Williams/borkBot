class WebhooksController < ApplicationController

  def hook
    message_payload = {
      "token": "#{Rails.application.secrets.borkBot_oauth}",
      "channel": "#cse-kpi-alerts"
    }
    
    title = params["title"]
    
    if title_contains?("Warn") #amber
      message_payload["text"] = "It Ambork"
      res = HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
      p "*" *50
      p res.body
    elsif title_contains?("Triggered") #red
      message_payload["text"] = "<!here> Oh no it red!!"
      res = HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
      p "*" *50
      p res.body
    elsif title_contains?("Recovered") #resolved
      message_payload["text"] = "It all good now"
      res = HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
      p "*" *50
      p res.body
    end
  end
  
  private
    def title_contains?(word)
      params["title"].scan(word).length > 0
    end
end
