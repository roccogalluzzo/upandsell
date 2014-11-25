class WithFeedbackInput < SimpleForm::Inputs::FileInput
  def input
    template.content_tag(:div, class: 'form-group has-feedback') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat icon_right
    end
  end

  def icon_right
    '<span class="form-control-feedback fa fa-2x fa-check text-success hidden"></span>'.html_safe
  end

end