class SwishNumber < ActiveRecord::Migration
  def change
    add_column :orders, :swish_number, :string, null: true
  end
end
