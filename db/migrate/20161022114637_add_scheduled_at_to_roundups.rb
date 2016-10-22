class AddScheduledAtToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :scheduled_at, :datetime
  end
end
