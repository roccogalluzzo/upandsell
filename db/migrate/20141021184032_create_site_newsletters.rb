class CreateSiteNewsletters < ActiveRecord::Migration
  def change
    create_table :site_newsletters do |t|
     t.string :subject
     t.text :content
     t.datetime :sent_at
     t.string :target, default: nil
   end
 end
end
