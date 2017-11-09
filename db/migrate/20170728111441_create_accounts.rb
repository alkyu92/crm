class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_type
      t.string :website
      t.string :email
      t.text :description
      t.string :phone
      t.string :fax
      t.string :industry
      t.integer :number_of_employee

      t.string :billing_street
      t.string :billing_city
      t.string :billing_state
      t.string :billing_postal_code
      t.string :billing_country

      t.string :shipping_street
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_postal_code
      t.string :shipping_country

      t.string :dummy

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
