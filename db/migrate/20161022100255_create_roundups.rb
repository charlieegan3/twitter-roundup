class CreateRoundups < ActiveRecord::Migration[5.0]
  def change
    create_table :roundups do |t|
      t.references :user, foreign_key: true
      t.text :monitored_accounts
      t.column :frequency, :integer, default: 0

      t.timestamps
    end
  end
end
