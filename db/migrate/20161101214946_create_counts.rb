class CreateCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :counts do |t|
      t.string :key
      t.integer :value

      t.timestamps
    end
  end
end
