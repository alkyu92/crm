class CreateAccnotes < ActiveRecord::Migration[5.0]
  def change
    create_table :accnotes do |t|
      t.string :title
      t.text :description

      t.references :account, foreign_key: true
      t.timestamps
    end
  end
end
