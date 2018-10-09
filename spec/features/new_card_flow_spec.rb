# require 'rails_helper'
# require 'rspec/given'

# describe 'New Card Flow' do

#   describe 'when user visits root path', js: true do

#     When {
#       visit root_path
#     }

#     Then { 'app shows the form for creating a new card' }
#     And {
#       expect(page).to have_content 'Varje droppe räknas!'
#       expect(page).to have_content 'Någon jag känner'
#       expect(page).to have_content 'Mig själv'
#     }

#     context 'creates a new card', js: true do
#       Given {
#         @num_of_cards = Card.count
#       }
#       When {
#         fill_in 'card_quantity', with: 100
#         fill_in 'card_receiver', with: 'rspec@email.com'
#         fill_in 'card_text', with: 'A simple text for the card'
#         fill_in 'card_from', with: 'Jack Sparrow'
#         click_button 'Lägg gåvobeviset i varukorgen'
#       }

#       Then { 'a card is created' }
#       And {
#         expect(page).to have_content 'Confirmation' # <---- this needs to be fixed
#         expect(Card.last.text).to eq 'A simple text for the card'
#         expect(@num_of_cards + 1).to eq Card.count
#       }

#       context 'when user edits the card', js: true do
#         When {
#           click_link '1 gåvobevis'
#           click_link 'ändra'
#           fill_in 'card_text', with: 'Another text for the card'
#           click_button 'Lägg gåvobeviset i varukorgen'
#         }

#         Then { 'a card is created which is shown to the user' }
#         And {
#           expect(page).to have_content 'Jag vill beställa'
#         }
#       end

#       context 'when user visits cart path', js: true do
#         When {
#           visit cart_path
#         }

#         Then { 'a summary of the cards is shown' }
#         And {
#           expect(page).to have_content 'Jag vill beställa'
#           [:receiver, :send_at, :price].each do |v|
#             expect(page).to have_content Card.first.send(v)
#           end
#         }
#         And {
#           expect(page).to have_content 'mina uppgifter'.upcase
#         }

#         context 'when chooses to pay by card', js: true do
#           Given(:prefix) { 'order_donor_attributes_' }
#           Given(:attributes) {
#             {
#               first_name: 'Jack',
#               last_name: 'Sparrow',
#               email: 'email@mail.com',
#               phone: '1231231231',
#               address: 'Address 123',
#               post_code: '12312',
#               city: 'Stockholm'
#             }

#           }

#           When {
#             attributes.each do |k, v|
#               fill_in "#{prefix}#{k.to_s}", with: v
#             end
#             click_button 'Fortsätt'
#           }

#           Then { 'it renders stripe checkout button' }
#           And {
#             expect(page).to have_content 'Here goes the partial for stripe button or invoice button'
#             expect(page).to have_button 'Purchase'
#           }

#           context 'when user chooses to pay by stripe', js: true do
#             When {
#               click_button 'Purchase'
#             }

#             Then { 'it renders stripe checkout' }
#             And {
#               accept_browser_dialog
#               stripe_iframe = all('iframe[name=stripe_checkout_app]').last
#               Capybara.within_frame stripe_iframe do
#                 expect(page).to have_content attributes[:email]
#               end
#             }
#           end
#         end
#       end
#     end
#   end
# end
