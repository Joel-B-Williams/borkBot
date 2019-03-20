class WebhooksController < ApplicationController

  def hook
    p "*" * 50
    p params
    p "="* 10
   
  end  

end
