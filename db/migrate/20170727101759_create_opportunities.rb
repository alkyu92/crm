class CreateOpportunities < ActiveRecord::Migration[5.0]
  def change
    create_table :opportunities do |t|
      t.string :name
      t.string :current_stage
      t.string :business_type
      t.string :probability
      t.string :amount
      t.text :description
      t.text :contacts
      t.string :loss_reason
      t.date :close_date
      t.string :status, default: "Open"

      t.references :account, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
