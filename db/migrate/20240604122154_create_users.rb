class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :address
      t.datetime :last_sign_in_at

      t.timestamps
    end
    add_index :users, :address, using: 'hash'
  end
end
