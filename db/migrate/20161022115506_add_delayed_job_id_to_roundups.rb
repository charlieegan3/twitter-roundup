class AddDelayedJobIdToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :delayed_job_id, :integer
  end
end
