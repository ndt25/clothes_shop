class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.integer :size

      t.timestamps null: false
    end
  end
end
