class ChangeRoomNumberType < ActiveRecord::Migration[5.0]
  def change
    change_column :rooms, :number, :string
  end
end
