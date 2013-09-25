class AddAttachmentThumbContentToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :thumb
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :products, :thumb
    drop_attached_file :products, :file
  end
end
