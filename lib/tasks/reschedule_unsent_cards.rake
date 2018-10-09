namespace :cards do

  desc "Re-schedule (or send) unsent cards"
  task :reschedule_unsent_cards => :environment do

    Card.unsent.each do |card|
      card.reschedule! if card.filled_out?
    end
  end
end
