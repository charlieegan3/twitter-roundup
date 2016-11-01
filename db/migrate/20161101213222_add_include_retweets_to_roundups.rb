class AddIncludeRetweetsToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :include_retweets, :boolean
  end
end
