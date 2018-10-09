class AddThumbnailToGiftcards < ActiveRecord::Migration
  def change
    add_column :giftcards, :thumbnail, :string
    add_column :giftcards, :preview_swedish, :string
    add_column :giftcards, :preview_english, :string
  end
end
