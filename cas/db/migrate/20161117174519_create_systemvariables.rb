class CreateSystemvariables < ActiveRecord::Migration[5.0]
  def change
    create_table :systemvariables do |t|
      t.string :name
      t.string :value
    end
  end
end
