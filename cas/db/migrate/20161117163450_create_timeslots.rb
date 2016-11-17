class CreateTimeslots < ActiveRecord::Migration[5.0]
  def change
    create_table :timeslots do |t|
      t.string :day
      t.integer :from_time
      t.integer :to_time

      t.timestamps
    end
  end
end
