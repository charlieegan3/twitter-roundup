class CreateRoundupReports < ActiveRecord::Migration[5.0]
  def change
    create_table :roundup_reports do |t|
      t.text :tweets
      t.references :roundup, foreign_key: true

      t.timestamps
    end
  end
end
