class CreateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :calls do |t|
      t.text :description
      t.integer :duration
      t.datetime :call_datetime
      t.boolean :complete, default: false

      t.references :opportunity, foreign_key: true
      t.timestamps
    end
  end
end
