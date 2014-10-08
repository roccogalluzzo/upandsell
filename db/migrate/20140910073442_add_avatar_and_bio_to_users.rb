class AddAvatarAndBioToUsers < ActiveRecord::Migration
  def change
   add_column :users, :avatar, :string
   add_column :users, :bio, :string
 end
end
