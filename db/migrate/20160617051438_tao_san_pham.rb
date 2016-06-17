class TaoSanPham < ActiveRecord::Migration
  def change
  	create_table :san_pham do |t|
  		t.string :ten_san_pham
  		t.integer :so_luong_con_lai
  	end
  end
end
