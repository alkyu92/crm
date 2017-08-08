class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :department
      t.string :email
      t.string :phone
      t.string :address

      t.references :account, foreign_key: true
      t.timestamps
    end
  end
end
