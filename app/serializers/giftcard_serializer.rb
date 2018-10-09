class GiftcardSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :category, :in_which_store, :amount
end
