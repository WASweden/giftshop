class AddJobIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :job_id, :string
  end
end
