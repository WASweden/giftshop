require 'rails_helper'

RSpec.describe "giftcards/show", type: :view do
  before(:each) do
    @giftcard = assign(:giftcard, Giftcard.create!(
      :name => "Name",
      :description => "MyText",
      :category => "Category",
      :in_which_store => "In Which Store",
      :amount => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/In Which Store/)
    expect(rendered).to match(/2/)
  end
end
