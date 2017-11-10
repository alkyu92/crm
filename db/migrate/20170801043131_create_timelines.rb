class CreateTimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :timelines do |t|
      t.string :action
      t.string :anchor
      t.references :activity, polymorphic: true, index: true

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
