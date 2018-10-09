class RemoveCardAttributes < ActiveRecord::Migration
  def up
    remove_columns :cards, :image, :hide_amount, :from
  end

  def down
    add_column :cards, :image, :string
    add_column :cards, :from, :string
    add_column :cards, :hide_amount, :boolean, default: false
  end
end
