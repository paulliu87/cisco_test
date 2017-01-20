class CreateLunchOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :lunch_orders do |t|

      t.timestamps
    end
  end
end
