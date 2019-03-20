# README

ngrok to 3000 (rails default)
rails s
(opt) set devhub webhook to ngrok instance
set datadog webhook to ngrok instance

Example webhook response:

<ActionController::Parameters {"body"=>"%%%\n\nThis is a test of the Red metric\n \n\n @slack-jw-borkbot-alert-test @webhook-jw-test-cse-wait-time\n\n[![Metric Graph](https://p.datadoghq.com/snapshot/view/dd-snapshots-prod/org_32497/2019-03-20/358d27f691853d30f521a41f848754524739086f.png)](https://app.datadoghq.com/monitors#8755429?to_ts=1553100939000&from_ts=1553099979000)\n\n**production.CustomerSupport.CSEWaitTime** over **\\*** was **> 30.0** on average during the **last 1m**.\n\nThe monitor was last triggered at Wed Mar 20 2019 16:54:49 UTC (**2 secs ago**).\n\n- - -\n\n[[Monitor Status](https://app.datadoghq.com/monitors#8755429?)] · [[Edit Monitor](https://app.datadoghq.com/monitors#8755429/edit)]\n%%%", "last_updated"=>"1553100891000", "event_type"=>"metric_alert_monitor", "title"=>"[Triggered] CSE - JW Test Monitor - Wait Time", "date"=>"1553100891000", "org"=>{"id"=>"32497", "name"=>"Intercom"}, "id"=>"4845897947474871035", "controller"=>"webhooks", "action"=>"hook", "webhook"=>{"body"=>"%%%\n\nThis is a test of the Red metric\n \n\n @slack-jw-borkbot-alert-test @webhook-jw-test-cse-wait-time\n\n[![Metric Graph](https://p.datadoghq.com/snapshot/view/dd-snapshots-prod/org_32497/2019-03-20/358d27f691853d30f521a41f848754524739086f.png)](https://app.datadoghq.com/monitors#8755429?to_ts=1553100939000&from_ts=1553099979000)\n\n**production.CustomerSupport.CSEWaitTime** over **\\*** was **> 30.0** on average during the **last 1m**.\n\nThe monitor was last triggered at Wed Mar 20 2019 16:54:49 UTC (**2 secs ago**).\n\n- - -\n\n[[Monitor Status](https://app.datadoghq.com/monitors#8755429?)] · [[Edit Monitor](https://app.datadoghq.com/monitors#8755429/edit)]\n%%%", "last_updated"=>"1553100891000", "event_type"=>"metric_alert_monitor", "title"=>"[Triggered] CSE - JW Test Monitor - Wait Time", "date"=>"1553100891000", "org"=>{"id"=>"32497", "name"=>"Intercom"}, "id"=>"4845897947474871035"}} permitted: false>

