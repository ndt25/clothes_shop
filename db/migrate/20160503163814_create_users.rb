class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :name
      t.date :birthday
      t.string :address
      t.string :number_phone
      t.string :role

      t.timestamps null: false
    end
  end
end
