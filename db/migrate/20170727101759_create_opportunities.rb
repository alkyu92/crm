class CreateOpportunities < ActiveRecord::Migration[5.0]
  def change
    create_table :opportunities do |t|
      t.string :name
      t.string :probability
      t.decimal :amount, precision: 8, scale: 2, default: 0.0
      t.text :description
      t.string :loss_reason
      t.date :close_date
      t.string :status, index: true

      t.string :dummy

      t.references :account, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
