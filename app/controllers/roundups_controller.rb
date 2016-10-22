class RoundupsController < ApplicationController
  before_filter :authorize

  def new
    @roundup = Roundup.new
  end

  def create
    @roundup = Roundup.create(roundup_params)
    redirect_to roundup_path(@roundup)
  end

  def show
    @roundup = Roundup.find(params[:id])
  end

  private

  def roundup_params
    params
      .require(:roundup)
      .permit(:monitored_accounts, :frequency)
      .merge(user: current_user)
  end
end
