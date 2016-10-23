class AddLinksOnlyToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :links_only, :boolean
  end
end
