class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?
  before_action :set_locale

  def render(*args)
    assign_counts
    super
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :name, :password, :password_confirmation, :street_name, :street_number, :postal_code, :city) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
  end

  def redirect_to_back(options = {}, default = root_path)
    if request.env['HTTP_REFERER'].present? && request.env['HTTP_REFERER'] != request.env['REQUEST_URI']
      redirect_to :back, options
    else
      redirect_to default, options
    end
  end

  def assign_counts
    @unread_conversations_count = current_user.present? ? current_user.mailbox.inbox(unread: true).count : 0
  end

  def success_message(options = {})
    translate_message(:success, options)
  end

  def error_message(options = {})
    translate_message(:error, options)
  end

  def message_scope
    [:controllers] + self.class.name.deconstantize.split('::').map(&:underscore) + [controller_name, params[:action]]
  end

  def translate_message(kind, options)
    sub_type = options.delete(:sub_type)
    scope = message_scope
    if sub_type.nil?
      key = kind
    else
      scope << kind
      key = sub_type
    end
    I18n.t key, options.merge(scope: scope)
  end

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header
  end

  def extract_locale_from_accept_language_header
    case request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    when 'de'
      'de'
    else
      'en'
    end
  end
end
