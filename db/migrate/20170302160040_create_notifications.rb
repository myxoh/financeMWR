class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.boolean :read
      t.references :subscription, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
