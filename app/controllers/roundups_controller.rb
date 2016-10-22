class RoundupsController < ApplicationController
  before_filter :authorize

  def index
    @roundups = Roundup.where(user: current_user).order(:created_at)
  end

  def new
    @roundup = Roundup.new
  end

  def create
    @roundup = Roundup.create(roundup_params)
    redirect_to roundups_path
  end

  def edit
    @roundup = Roundup.find(params[:id])
  end

  def update
    @roundup = Roundup.find(params[:id])
    puts @roundup
    puts roundup_params.inspect
    @roundup.update_attributes!(roundup_params)
    redirect_to roundups_path
  end

  def destroy
    Roundup.find(params[:id]).destroy
    redirect_to roundups_path
  end

  private

  def roundup_params
    params
      .require(:roundup)
      .permit(:monitored_accounts, :frequency)
      .merge(user: current_user)
  end
end
