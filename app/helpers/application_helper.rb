module ApplicationHelper

  def product_facebook_url(product, title)
    URI.escape("https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(product.slug)}&title=#{title}")
  end

  def product_twitter_url(product, title)
    URI.escape(
      "https://twitter.com/intent/tweet?text=#{title} #{product_slug_url(product.slug)}")
  end

  def gravatar_for email, options = {}
    options = {:alt => 'avatar', :class => 'avatar', :size => 80}.merge! options
    id = Digest::MD5::hexdigest email.strip.downcase
    url = 'https://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s + '&d=identicon'
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

 def title(page_title)
  content_for(:title) { page_title }
end

def is_admin?
  current_user.admin?
end
def rot13(string)
  string.tr "A-Za-z", "N-ZA-Mn-za-m"
end

def ap(path)
  "active" if current_page?(path)
end

def ac(controller)
  'active' if controller_name == controller
end

def currency_symbol(currency)
  cur = {eur: '€', usd: '$', gbp: '£'}
  cur[currency.downcase.to_sym].html_safe
end

def step(icon, success = false)
  if success
    "<div class=\"cbp_tmicon success animated bounceIn\">
    <i class=\"fa fa-check-circle-o fa-lg\"></i> </div>".html_safe
  else
    "<div class=\"cbp_tmicon info animated bounceIn\">
    <i class=\"fa #{icon}\"></i> </div>".html_safe
  end
end

end
