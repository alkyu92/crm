class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.attachment :doc

      t.references :opportunity, foreign_key: true
      t.timestamps
    end
  end
end
