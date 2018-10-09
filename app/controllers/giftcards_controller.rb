class GiftcardsController < InheritedResources::Base

  def foretag
    @giftcards = Giftcard.where(:in_which_store => 'foretag')
  end

  private

    def giftcard_params
      params.require(:giftcard).permit(:name, :description, :category, :in_which_store, :amount)
    end
end
