Rails.application.routes.draw do

  post "/", to: "webhooks#hook"

end
