class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text :description
      t.date :due_date
      t.boolean :complete, default: false

      t.references :opportunity, foreign_key: true
      t.timestamps
    end
  end
end