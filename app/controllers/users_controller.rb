class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:destroy, :edit, :show, :update]
  after_action :verify_authorized

  def edit
    authorize @user
  end

  def update
    @user.assign_attributes permitted_attributes(@user)
    authorize @user
    if @user.save
      name = @user == current_user ? I18n.t(:your_account, scope: [:views, :common]) : "#{I18n.t(:account_of, scope: [:views, :common])} #{@user.name}"
      redirect_to @user, notice: success_message(name: name)
    else
      render 'new'
    end
  end

  def index
    @users = User.all
    authorize User
  end

  def show
    authorize @user
  end

  def destroy
    authorize @user
    if user.destroy
      redirect_to users_path, notice: success_message(name: @user.name)
    else
      redirect_to @user, alert: error_message(name: @user.name)
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
