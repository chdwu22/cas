class CreateTimeslotUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :timeslot_users do |t|
      t.integer :timeslot_id
      t.integer :user_id
      t.integer :preference_type
    end
  end
end
