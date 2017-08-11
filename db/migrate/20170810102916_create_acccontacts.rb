class CreateAcccontacts < ActiveRecord::Migration[5.0]
  def change
    create_table :acccontacts do |t|
      t.string :name
      t.string :title
      t.string :department
      t.string :email
      t.string :phone
      t.string :fax

      t.string :mailing_street
      t.string :mailing_city
      t.string :mailing_state
      t.string :mailing_postal_code
      t.string :mailing_country

      t.references :account, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
