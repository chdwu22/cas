class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :number
      t.string :section
      t.string :name
      t.integer :size
      t.string :day
      t.string :time
      t.integer :year
      t.string :semester
      t.integer :room_id, :null=>true
      t.integer :user_id, :null=>true

      t.timestamps
    end
  end
end
