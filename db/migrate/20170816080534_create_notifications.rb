class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.boolean :read, default: false
      t.string :action
      t.string :nactivity
      t.string :tactivity

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
