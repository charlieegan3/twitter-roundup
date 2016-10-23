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
    @roundup.schedule_job(Time.zone.now)
    flash[:success] = "#{@roundup.list_of_monitored_accounts.join(', ')} roundup created; initial report refresh triggered - check back shortly."
    redirect_to roundups_path
  end

  def edit
    @roundup = Roundup.find(params[:id])
  end

  def update
    @roundup = Roundup.find(params[:id])
    @roundup.update_attributes!(roundup_params)
    flash[:success] = 'Roundup updated successfully.'
    redirect_to roundups_path + "#roundup-#{@roundup.id}"
  end

  def destroy
    Roundup.find(params[:id]).destroy
    flash[:success] = 'Roundup deleted successfully.'
    redirect_to roundups_path
  end

  def refresh
    roundup = Roundup.find(params[:id])
    if roundup.manually_refreshable?
      roundup.schedule_job(Time.zone.now)
      flash[:success] = 'Refresh triggered, check back shortly.'
    end
    redirect_to roundups_path + "#roundup-#{roundup.id}"
  end

  private

  def roundup_params
    params
      .require(:roundup)
      .permit(:monitored_accounts, :frequency, :webhook_endpoint, :email_address, :whitelist, :blacklist, :links_only)
      .merge(user: current_user)
  end
end
