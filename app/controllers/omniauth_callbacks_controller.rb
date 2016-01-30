class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      redirect_after_authentication
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def redirect_after_authentication
    if @user.postal_code.blank? || @user.city.blank?
      sign_in @user, event: :authentication
      redirect_to edit_user_path(@user), notice: success_message(sub_type: :completed_location_missing)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end
end
