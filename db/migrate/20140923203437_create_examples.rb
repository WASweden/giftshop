class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.text    :description
      t.integer :amount
      t.string  :country
      t.boolean :active

      t.timestamps
    end
  end
end
