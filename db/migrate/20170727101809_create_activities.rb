class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.datetime :due_date
      t.string :subject
      t.text :comments
      t.integer :priority_id, null: false, default: 1
      t.integer :status_id,   null: false, default: 1
      t.text :assigned_to
      t.text :related_to
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
