class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :contact_id
      t.integer :contactable_id
      t.string :contactable_type
      
      t.timestamps
    end
  end
end
