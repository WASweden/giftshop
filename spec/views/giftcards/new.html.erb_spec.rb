require 'rails_helper'

RSpec.describe "giftcards/new", type: :view do
  before(:each) do
    assign(:giftcard, Giftcard.new(
      :name => "MyString",
      :description => "MyText",
      :category => "MyString",
      :in_which_store => "MyString",
      :amount => 1
    ))
  end

  it "renders new giftcard form" do
    render

    assert_select "form[action=?][method=?]", giftcards_path, "post" do

      assert_select "input#giftcard_name[name=?]", "giftcard[name]"

      assert_select "textarea#giftcard_description[name=?]", "giftcard[description]"

      assert_select "input#giftcard_category[name=?]", "giftcard[category]"

      assert_select "input#giftcard_in_which_store[name=?]", "giftcard[in_which_store]"

      assert_select "input#giftcard_amount[name=?]", "giftcard[amount]"
    end
  end
end
