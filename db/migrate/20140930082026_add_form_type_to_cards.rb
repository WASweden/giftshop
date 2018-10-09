class AddFormTypeToCards < ActiveRecord::Migration
  def change
    add_column :cards, :form_type, :string
  end
end
