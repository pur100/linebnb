class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    if current_user.is_q
      @queuer = Queuer.find_by(user: current_user)
      @reservations_as_queuer = Reservation.where(queuer: @queuer)
      @reviews_as_queuer = @queuer.reviews
    end
    @reservations_as_user = Reservation.where(user: current_user)
    @reviews_as_user = current_user.reviews
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :picture, :rating, :is_q, :description)
  end

  def set_user
    @user = current_user
  end
end
