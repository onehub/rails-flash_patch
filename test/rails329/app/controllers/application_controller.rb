class ApplicationController < ActionController::Base
  protect_from_forgery

  def action_with_flash
    flash[:warn] = 'foo'
    render :nothing => true
  end
end
