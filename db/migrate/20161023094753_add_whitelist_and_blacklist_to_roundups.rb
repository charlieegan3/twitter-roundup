class AddWhitelistAndBlacklistToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :whitelist, :text
    add_column :roundups, :blacklist, :text
  end
end
