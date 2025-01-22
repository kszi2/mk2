class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit edit_password update update_password destroy]

  def index
    authorize User
    @users = policy_scope(User).order(:username).page(params[:page]).per(params[:per_page] || 50)
  end

  def show
  end

  def new
    @user = User.new
    authorize @user
  end

  def edit
  end

  def edit_password
  end

  def create
    @user = User.new(user_params_creation)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_without_password(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    respond_to do |format|
      if @user.update_with_password(user_params_with_password)
        format.html { redirect_to user_url(@user), notice: 'User password was successfully updated.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :edit_password, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end

  def user_params_creation
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def user_params_with_password
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def set_user
    @user = User.public_find(params[:id] || params[:user_id])
    authorize @user
  end
end
