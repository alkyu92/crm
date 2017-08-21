class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.string :name
      t.string :status, null: false, default: "Waiting"
      t.boolean :current_status, null: false, default: false
      
      t.references :opportunity, foreign_key: true
      t.timestamps
    end
  end
end
