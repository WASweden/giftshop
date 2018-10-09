require 'rails_helper'

RSpec.describe "giftcards/index", type: :view do
  before(:each) do
    assign(:giftcards, [
      Giftcard.create!(
        :name => "Name",
        :description => "MyText",
        :category => "Category",
        :in_which_store => "In Which Store",
        :amount => 2
      ),
      Giftcard.create!(
        :name => "Name",
        :description => "MyText",
        :category => "Category",
        :in_which_store => "In Which Store",
        :amount => 2
      )
    ])
  end

  it "renders a list of giftcards" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => "In Which Store".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
