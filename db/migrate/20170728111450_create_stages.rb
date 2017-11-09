class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.string :name
      t.string :status, null: false, default: "Waiting"
      t.boolean :current_status, null: false, default: false
      t.integer :updated_by_id

      t.references :polystage, polymorphic: true, index: true

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
