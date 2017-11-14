class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.text :description
      t.datetime :event_date
      t.datetime :event_finish
      t.boolean :complete, default: false

      t.references :polyevent, polymorphic: true, index: true

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
