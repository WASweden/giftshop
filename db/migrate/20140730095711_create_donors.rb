class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|
      t.references :order

      t.string  :donor_type,   default: 'person'
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :company
      t.string  :org_number
      t.string  :phone
      t.text    :address
      t.string  :post_code
      t.string  :city
      t.string  :country_code
      t.boolean :newsletter,   default: true

      t.timestamps
    end

    add_index :donors, :donor_type
  end
end
