class CreateOpportunities < ActiveRecord::Migration[5.0]
  def change
    create_table :opportunities do |t|
      t.string :name
      t.integer :stage_id
      t.integer :account_id
      t.date :close_date
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
