class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :description
      t.float :amount
      t.jsonb :data
      t.belongs_to :user
      t.belongs_to :order
      t.timestamps
    end
  end
end
