class Product
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include API

  attr_accessor :id, :slug, :name, :price, :currency, :file, :file_key,
  :description, :preview, :published, :user_id



  def initialize(params = {})
    params.each { |key, value| send "#{key}=", value }
  end

  def find(id)
    response = API.api.get("products/#{id}").body
    update_attributes(response)
    self
  end

  def find_by_slug(slug)
    response = API.api.get('products', slug: slug).body[0].symbolize_keys
    update_attributes(response)
    self
  end

  def self.file(name)
    API.api.post('products/file', name: name).body
  end

  def create
   response = API.api.post('products', attributes).body.symbolize_keys
   update_attributes(response)
   true
 end

 def update
  response = API.api.put("products/#{@id}", attributes).body.symbolize_keys
  update_attributes(response)
  true
end

def destroy
 API.api.delete("products/#{@id}")
end

def publish
  API.api.put("products/#{@id}/published")
end

def unpublish
 API.api.delete("products/#{@id}/published")
end

def update_attributes(attrs)
 attrs.each { |key, value| send "#{key}=", value }
end

def self.user(user_id, page = 1, per_page = 5)
  if page.blank?
    page = 1
  end
  response  = API.api.get("products/user/#{user_id}", page: page, per_page: per_page)
  response.body.map { |x| x.symbolize_keys }
end

def extension
 File.extname(self.file_file_name).delete('.')
end

def persisted?
  true unless  @id.blank?
end

def attributes
  if !@preview.blank? && @preview.instance_of?(ActionDispatch::Http::UploadedFile)
    preview =  Faraday::UploadIO.new(@preview.path, @preview.content_type)
  else
    preview = nil
  end
  {name: @name, price: @price, currency: @currency, file_key: @file_key,
    description: @description, preview: preview, published: @published,
    user_id: @user_id}
  end
end
