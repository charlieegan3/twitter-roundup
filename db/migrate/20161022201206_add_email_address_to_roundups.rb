class AddEmailAddressToRoundups < ActiveRecord::Migration[5.0]
  def change
    add_column :roundups, :email_address, :string
  end
end
