class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :discount
      t.date :expires_at

      t.timestamps null: false
    end
  end
end
