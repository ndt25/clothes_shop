class UploadFilesAddObjectId < ActiveRecord::Migration
  def change
  	add_column :upload_files, :object_id, :integer
  end
end
