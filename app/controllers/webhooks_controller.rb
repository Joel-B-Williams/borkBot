class WebhooksController < ApplicationController

  def hook
    # p "*" * 50
    # p params
    # p "="* 10
    # body = params["body"].split
    # title = params["title"]
    # p body
    # p "="* 10
    # p title
    # p "="* 10
    # p "Red?"
    # p body.include?("RED")
    # p title_contains?("Triggered")
    # p "="* 10
    # p "Amber?"
    # p body.include?("AMBER")
    # p title_contains?("Warn")
    # p "="* 10
    # p "Recovered?"
    # p title_contains?("Recovered")
    # p "*" * 50
    
    message_payload = {
      "token": "#{Rails.application.secrets.borker_oauth}",
      "channel": "#borkbot"
    }
    
    title = params["title"]
    
    if title_contains?("Warn") #amber
      message_payload["text"] = "It Ambork"
      HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
    elsif title_contains?("Triggered") #red
      message_payload["text"] = "Oh no it red!!"
      HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
    elsif title_contains?("Recovered") #resolved
      message_payload["text"] = "It all good now"
      HTTParty.post('https://slack.com/api/chat.postMessage', body: message_payload)
    end
  end
  
  private
    def title_contains?(word)
      params["title"].scan(word).length > 0
    end

end
