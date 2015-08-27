class CreateBooksUsers < ActiveRecord::Migration
  def change
    create_table :books_users, id: false do |t|
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
    end
    add_index :books_users, [:user_id, :book_id], unique: true
  end
end
