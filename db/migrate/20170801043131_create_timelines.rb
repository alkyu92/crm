class CreateTimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :timelines do |t|
      t.string :tactivity, null: false, default: "opportunity"
      t.string :nactivity
      t.string :action

      t.references :opportunity, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
