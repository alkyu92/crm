class CreateAcctimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :acctimelines do |t|
      t.string :tactivity
      t.string :nactivity
      t.string :action

      t.references :account, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
