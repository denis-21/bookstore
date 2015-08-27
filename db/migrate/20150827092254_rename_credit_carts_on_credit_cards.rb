class RenameCreditCartsOnCreditCards < ActiveRecord::Migration
  def change
    rename_table :credit_carts, :credit_cards
  end
end
