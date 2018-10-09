class AddSubtypeToCards < ActiveRecord::Migration
  def up
    add_column :cards, :subtype, :string, default: nil

    Card.update_all subtype: "regular"
  end

  def down
    remove_column :cards, :subtype
  end
end
