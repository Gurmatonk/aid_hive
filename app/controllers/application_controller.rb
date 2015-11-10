class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def success_message(options = {})
    translate_message(:success, options)
  end

  def error_message(options = {})
    translate_message(:error, options)
  end

  def translate_message(kind, options)
    sub_type = options.delete(:sub_type)
    scope = ([:controllers] + self.class.name.deconstantize.split('::').map(&:underscore) << controller_name << params[:action])
    if sub_type.nil?
      key = kind
    else
      scope << kind
      key = sub_type
    end
    I18n.t key, options.merge(scope: scope)
  end
end
