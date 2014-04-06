module ApplicationHelper
  def gravatar_for email, options = {}
    options = {:alt => 'avatar', :class => 'avatar', :size => 80}.merge! options
    id = Digest::MD5::hexdigest email.strip.downcase
    url = 'http://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s + '&d=identicon'
    options.delete :size
    image_tag url, options
  end 
  
  def bootstrap_class_for flash_type
   case flash_type
   when :success
   "alert-success"
   when :error
   "alert-error"
   when :alert
   "alert-block"
   when :notice
   "alert-info"
   else
   flash_type.to_s
   end
end
end
