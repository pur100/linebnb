class ReservationsController < ApplicationController
 before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  def index
    @reservations = Reservation.all
  end

  def show
  end

  def statut
    @reservation = Reservation.find(params[:id])
    if @reservation.statut == "process"
      @reservation.statut = "finished"
    else
      @reservation.statut = "process"
    end
    @reservation.save
    redirect_to user_path(current_user)
  end

  def declined
    @reservation = Reservation.find(params[:id])
    @reservation.statut = "aborted"
    @reservation.save
    redirect_to user_path(current_user)
  end

  def new
    @user = current_user
    @queuer = Queuer.find(params[:queuer_id])
    @reservation = Reservation.new
  end

  def edit
  end

  def create
    @queuer = Queuer.find(params[:queuer_id])
    @user = current_user
    @reservation = Reservation.new(reservation_params)
    @reservation.statut = "waiting"
    @reservation.user = @user
    @reservation.queuer = @queuer
    if @reservation.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def update
      if @reservation.update(reservation_params)
        redirect_to user_path(current_user)
      else
        render :edit
      end
  end

  def destroy
    @queuer = Queuer.find(params[:queuer_id])
    @user = current_user
    @reservation.destroy
    redirect_to user_path(current_user)
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:starts_at, :ends_at, :content, :address)
  end
end
