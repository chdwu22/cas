class AddAvailabilityToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :available_time, :string
  end
end
