ActiveAdmin.register Order do
  actions :all, except: [:new, :edit, :destroy]

  scope :completed, default: true
  scope :pending
  scope :exportable
  scope :company

  filter :order_id
  filter :stripe_charge_id

  filter :donor_first_name, as: :string, label: I18n.t(:first_name, scope: 'activerecord.attributes.donor')
  filter :donor_last_name,  as: :string, label: I18n.t(:last_name, scope: 'activerecord.attributes.donor')
  filter :donor_email,      as: :string, label: I18n.t(:email, scope: 'activerecord.attributes.donor')
  filter :donor_company,    as: :string, label: I18n.t(:company, scope: 'activerecord.attributes.donor')

  filter :payment_type, as: :select, collection: Order::PAYMENT_TYPES.map { |k,v| [I18n.t(k, scope: 'activerecord.constants.payment_type'), v] }
  filter :digital_cards_count, as: :numeric
  filter :analog_cards_count, as: :numeric
  filter :total
  filter :paid_at
  filter :created_at
  filter :updated_at

  menu :priority => 1

  permit_params(
    :id,
    :donor,
    donor_attributes: [
      :id, :first_name, :last_name, :company_name, :email, :company
    ],
    cards_attributes: [:id, :text, :quantity, :receiver, :send_at]
  )

  controller do
    def scoped_collection
      Order.includes(:donor)
    end
  end

  index do
    column :order_id
    column :stripe_charge_id
    column :swish_id do |order|
      if swish_payments = order.swish_payments.presence
        swish_payments.map(&:payment_id).join(", ")
      end
    end
    column I18n.t(:first_name, scope: 'activerecord.attributes.donor'), :first_name, sortable: 'donors.first_name' do |order|
      order.donor.first_name if order.donor
    end
    column I18n.t(:last_name, scope: 'activerecord.attributes.donor'), :last_name, sortable: 'donors.last_name' do |order|
      order.donor.last_name if order.donor
    end
    column I18n.t(:email, scope: 'activerecord.attributes.donor'), :email, sortable: 'donors.email' do |order|
      order.donor.email if order.donor
    end
    column I18n.t(:company, scope: 'activerecord.attributes.donor'), :company, sortable: 'donors.company' do |order|
      order.donor.company if order.donor
    end
    column :total
    column :payment_type do |order|
      I18n.t(order.payment_type, scope: 'activerecord.constants.payment_type')
    end
    column :digital_cards_count
    column :analog_cards_regular_count
    column :analog_cards_xmas_count
    column :paid_at
    column :created_at
    column :updated_at

    actions
  end

  show do |order|
    columns do
      column do
        panel I18n.t(:one, scope: 'activerecord.models.donor') do
          if order.donor
            attributes_table_for order.donor do
              row :donor_type do |donor|
                I18n.t(donor.donor_type, scope: 'activerecord.constants.donor_type')
              end
              row :first_name
              row :last_name
              row :email
              row :company
              row :org_number
              row :phone
              row :address
              row :post_code
              row :city
              row :country_code
              row :newsletter do |donor|
                donor.newsletter? ? status_tag('yes', :yes) : status_tag('no', :no)
              end
              row ' ' do |donor|
                link_to(I18n.t(:edit, scope: 'active_admin'), edit_admin_donor_path(donor))
              end
            end
          end
        end
      end
      column do
        panel I18n.t(:one, scope: 'activerecord.models.order') do
          attributes_table_for order do
            row :id
            row :total do |order|
              order.total
            end
            row :payment_type do |order|
              I18n.t(order.payment_type, scope: 'activerecord.constants.payment_type')
            end
            row :paid_at
            row :created_at
            row :updated_at
          end
        end
      end
    end

    panel I18n.t(:one, scope: 'activerecord.models.card') do
      table_for order.cards do
        column :type do |card|
          card
        end
        column :subtype do |card|
          card.subtype
        end
        column :receiver
        column :product_quantity do |card|
          1
        end
        column :price do |card|
          card.price
        end
        column :send_at
        column :sent_at

        column '', :actions do |card|
          output = []

          if card.type == 'DigitalCard'
            output << link_to(I18n.t(:view, scope: 'active_admin'), card_path(card.token), :target => :blank)

            #output << link_to(I18n.t(:edit, scope: 'active_admin'), edit_admin_card_path(card))

            if card.sent_at
              output << link_to('Visningar', "https://mixpanel.com/report/#{Rails.application.secrets.mixpanel_id}/segmentation/#action:segment,arb_event:'View%20card',bool_op:and,chart_type:line,from_date:-29,segfilter:!((filter:(operand:!('#{card.id}'),operator:%3D%3D),property:card-id,selected_property_type:string,type:string)),to_date:0,type:general,unit:day", :target => :blank)

              card_email_encoded = CGI::escape(card.receiver)
              card_email_start_date = Date.today - 90 # Mandrill stores max 90 days
              card_email_start_date = CGI::escape(card_email_start_date.strftime('%m/%d/%Y'))
              card_email_stop_date = CGI::escape(Date.today.strftime('%m/%d/%Y'))
              output << link_to('Mailinfo', "https://mandrillapp.com/activity?date_format=mm%2Fdd%2Fyy&q=#{card_email_encoded}&date_range=90&start_date=#{card_email_start_date}&stop_date=#{card_email_stop_date}&tag=_all&sender=", :target => :blank)
            end
          end

          output.join(' ').to_s.html_safe
        end
      end
    end
  end

  csv do
    column('Reference ID', humanize_name: false) { |order|
      order.stripe_charge_id
    }
    column('First Name', humanize_name: false) { |order|
      order.try(:donor).try(:first_name)
    }
    column('Last Name', humanize_name: false) { |order|
      order.try(:donor).try(:last_name)
    }
    column('Organisation Name', humanize_name: false) { |order|
      order.try(:donor).try(:company) if order.try(:donor).try(:donor_type) == 'company'
    }
    column('Address Line 1', humanize_name: false) { |order|
      order.try(:donor).try(:address)
    }
    column('Address Line 2', humanize_name: false) { nil }
    column('City') { |order|
      order.try(:donor).try(:city)
    }
    column('Postcode', humanize_name: false) { |order|
      order.try(:donor).try(:post_code)
    }
    column('Country', humanize_name: false) { |order|
      order.try(:donor).try(:country_code)
    }
    column('Mobile Phone', humanize_name: false) { |order|
      order.try(:donor).try(:phone) unless order.try(:donor).try(:phone).try(:blank?)
    }
    column('Email Address', humanize_name: false) { |order|
      order.try(:donor).try(:email)
    }
    column('Gift Date', humanize_name: false) { |order|
      order.paid_at.strftime('%Y-%m-%d %H:%M:%S') unless order.paid_at.nil?
    }
    column('Gift Amount', humanize_name: false) { |order|
      order.total.to_f
    }
    column('Prompt Reason', humanize_name: false) { 'Gåvoshop' }
    column('Organisation Number', humanize_name: false) { |order|
      order.try(:donor).try(:org_number) if order.try(:donor).try(:donor_type) == 'company'
    }
    column('Corporate Partner', humanize: false) { 'J/N' }
    column('Digital Cards', humanize: false) { |order|
      order.digital_cards_count
    }
    column('Analog Cards', humanize: false) { |order|
      order.analog_cards_count
    }
    column('Analog Regular Cards', humanize: false) { |order|
      order.analog_cards_regular_count
    }
    column('Analog Xmas Cards', humanize: false) { |order|
      order.analog_cards_xmas_count
    }
  end
end
