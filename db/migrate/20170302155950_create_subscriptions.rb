class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :ticket
      t.timestamp :last_checked
      t.integer :frequency
      t.float :range_min
      t.float :range_max

      t.timestamps
    end
  end
end
