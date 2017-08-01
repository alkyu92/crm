class CreateTimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :timelines do |t|
      t.integer :id_of_activity
      t.string :type_of_activity
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
