require 'rails_helper'

RSpec.describe "giftcards/edit", type: :view do
  before(:each) do
    @giftcard = assign(:giftcard, Giftcard.create!(
      :name => "MyString",
      :description => "MyText",
      :category => "MyString",
      :in_which_store => "MyString",
      :amount => 1
    ))
  end

  it "renders the edit giftcard form" do
    render

    assert_select "form[action=?][method=?]", giftcard_path(@giftcard), "post" do

      assert_select "input#giftcard_name[name=?]", "giftcard[name]"

      assert_select "textarea#giftcard_description[name=?]", "giftcard[description]"

      assert_select "input#giftcard_category[name=?]", "giftcard[category]"

      assert_select "input#giftcard_in_which_store[name=?]", "giftcard[in_which_store]"

      assert_select "input#giftcard_amount[name=?]", "giftcard[amount]"
    end
  end
end
