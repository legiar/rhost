class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  layout :get_layout
  
  private
    
    def get_layout
      devise_controller? ? "devise" : "application"
    end    
end
