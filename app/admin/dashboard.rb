ActiveAdmin.register_page "Dashboard" do
  page_action :chart, :method => :get

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    date_range = (Date.parse("2016-12-01")..Date.current.end_of_month)
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq

    columns do
      column do
        div class: 'dashboard-stats blue' do
          div class: 'dashboard-stats__visual' do
            i class: 'fa fa-bars'
          end
          div class: 'dashboard-stats__data' do
            para number_with_delimiter(Order.completed.count, separator: ',', delimiter: ' '), class: 'number'
            para 'Genomförda ordrar', class: 'description'
          end
        end
      end

      column do
        div class: 'dashboard-stats red' do
          div class: 'dashboard-stats__visual' do
            i class: 'fa fa-cogs'
          end
          div class: 'dashboard-stats__data' do
            para number_with_delimiter(Order.pending.count, separator: ',', delimiter: ' '), class: 'number'
            para 'Pågående ordrar', class: 'description'
          end
        end
      end

      column do
        div class: 'dashboard-stats yellow' do
          div class: 'dashboard-stats__visual' do
            i class: 'fa fa-certificate'
          end
          div class: 'dashboard-stats__data' do
            para number_to_currency(Order.completed.sum(:total), separator: ',', delimiter: ' ', precision: 0), class: 'number'
            para 'Total', class: 'description'
          end
        end
      end

      column do
        div class: 'dashboard-stats green' do
          div class: 'dashboard-stats__visual' do
            i class: 'fa fa-picture-o'
          end
          div class: 'dashboard-stats__data' do
            para number_with_delimiter(Order.completed.digital_cards.count, separator: ',', delimiter: ' '), class: 'number'
            para 'Gåvobevis - digitalt', class: 'description'
          end
        end
      end

      column do
        div class: 'dashboard-stats purple' do
          div class: 'dashboard-stats__visual' do
            i class: 'fa fa-gift'
          end
          div class: 'dashboard-stats__data' do
            para number_with_delimiter(Order.completed.analog_cards.count, separator: ',', delimiter: ' '), class: 'number'
            para 'Gåvobevis - tryckt', class: 'description'
          end
        end
      end
    end

    panel 'Graf' do
      div class: 'dashboard-chart', id: 'chart-1' do

      end
    end

    panel "Extragåvor" do
      br
      date_months.each do |date|
        start_date, end_date = date, date.end_of_month
        cards = Card.where(type: "Extra").where("created_at BETWEEN ? AND ?", start_date, end_date)

        div do
          h3 start_date.strftime("%B %Y")
          h4 "Antal extragåvor: #{cards.count}"
          h4 "Total summa: #{number_to_currency(number_with_delimiter(cards.sum(:quantity), separator: ',', delimiter: ' ', precision: 0))}"
          hr
          br
        end
      end
    end
  end

  controller do
    def chart
      orders = Order.arel_table
      cards  = Card.arel_table

      date = Arel::Nodes::NamedFunction.new 'date', [orders[:paid_at]]

      sql = orders.project(
        date,
        Arel::Nodes::NamedFunction.new(
          'count',
          [Arel::Nodes::NamedFunction.new('distinct', [orders[:id]])],
          'orders_count'
        ),
        Arel::Nodes::NamedFunction.new(
          'count',
          [Arel::Nodes::NamedFunction.new('distinct', [cards[:id]])],
          'cards_count'
        )
      )
      .join(cards, Arel::Nodes::OuterJoin).on(orders[:id].eq(cards[:order_id]))
      .where(orders[:paid_at].not_eq(nil))
      .group(date)
      .to_sql

      render json: ActiveRecord::Base.connection.execute(sql).to_json
    end
  end

end
