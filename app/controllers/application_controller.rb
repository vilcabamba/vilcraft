class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # exception notifier:
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
  end

  def routing_error
    render_not_found(nil)
  end

  protected

  def render_not_found(exception=nil)
    render :template => "/errors/404.html.erb", :layout => "application.html.erb", :status => 404
  end

  def render_error(exception)
    ExceptionNotifier::Notifier.exception_notification(request.env,exception).deliver
    render :template => "/errors/500.html.erb", :layout => "application.html.erb", :status => 500
  end


end