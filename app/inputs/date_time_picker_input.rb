## app/inputs/date_time_picker_input.rb
class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'date form_datetime') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      #template.concat span_table
    end
  end

  def input_html_options
    super.merge({class: 'form-control', readonly: false})
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    "<i class='glyphicon glyphicon-th'></i>".html_safe
  end

end
