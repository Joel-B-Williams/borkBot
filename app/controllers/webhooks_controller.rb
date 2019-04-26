class WebhooksController < ApplicationController

  def hook
    message_payload = {
      "token": "#{Rails.application.secrets.borkBot_oauth}",
      "channel": "#cse-kpi-alerts"
    }
    
    icom = Intercom::Client.new(token: Rails.application.secrets.icom_token)
    title = params["title"]

    slack_post = 'https://slack.com/api/chat.postMessage'
    vip_inbox = 2001586
    kpi_limit = 1.minutes.ago.to_i

    dd_api_key = Rails.application.secrets.dd_api_key
    dd_app_key = Rails.application.secrets.dd_app_key
    datadog_resolve = "https://app.datadoghq.com/monitor/bulk_resolve?api_key=#{dd_api_key}&application_key=#{dd_app_key}"
    # datadog_resolve = "https://app.datadoghq.com/monitor/bulk_resolve?api_key=21ea07c2d43462f80d54da7180ce53f4&application_key=43f5ed7cc0cb7d2bc360e684e8d5a994234d0296"
    cse_monitor = {"resolve": [{"8755429": "*"}]}
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'

    if title_contains?("Warn") #amber
      message_payload["text"] = "It Ambork"
      res = HTTParty.post(slack_post, body: message_payload)
    elsif title_contains?("Triggered") #red
      convos = get_from(vip_inbox, icom) 
      full_convos = get_full_convos(convos, icom)
      assign_times = get_assignment_times(full_convos, vip_inbox)
      red_convos = get_reds(assign_times, kpi_limit).length
      
      if red_convos > 0
        message_payload["text"] = "<!here> Oh no it red!! #{red_convos} over KPI"
        res = HTTParty.post(slack_post, body: message_payload) 
      else
        message_payload["text"] = "false alarm - Red count is #{red_convos}"
        res = HTTParty.post(slack_post, body: message_payload)
        resolve = HTTParty.post(datadog_resolve, :body => cse_monitor.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
      end

    elsif title_contains?("Recovered") #resolved
      
      # convos = get_from(vip_inbox, icom) 
      # full_convos = get_full_convos(convos, icom)
      # assign_times = get_assignment_times(full_convos, vip_inbox)

      
      # if get_reds(assign_times, kpi_limit).length > 0
      #   message_payload["text"] = "It all good now"
      #   res = HTTParty.post(slack_post, body: message_payload) 
      # else
      #   message_payload["text"] = "false alarm"
      #   res = HTTParty.post(slack_post, body: message_payload)
      #   #API to DD to resolve monitor
      # end
    end
  end
  
  private
    def title_contains?(word)
      params["title"].scan(word).length > 0
    end

    def get_from(inbox, icom)
      icom.conversations.find_all(open: true, type: "admin", id: inbox)
    end
    
    def get_full_convos(convo_list, icom)
      convo_list.map {|convo| convo.id}.map {|id| icom.conversations.find(id: id)}
    end
    
    def get_assignment_times(full_convos, inbox)
      full_convos.map do |convo|
        convo.conversation_parts.select { |p| (p.part_type=="assignment") && (p.assigned_to.id==inbox.to_s) }.max_by(&:created_at)
      end
    end
  
    def get_reds(assignment_parts, kpi_limit)
      assignment_parts.select {|assign| assign.created_at.to_i < kpi_limit}
    end
end
