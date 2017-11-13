class CreateCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :calls do |t|
      t.text :description
      t.integer :duration
      t.datetime :call_datetime

      t.references :polycall, polymorphic: true, index: true

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
