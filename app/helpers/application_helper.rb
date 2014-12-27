module ApplicationHelper
  def render_errors(model)
    error_messages = model.errors.full_messages.map do |message|
      content_tag(:li, message)
    end
    if error_messages.any?
      error_list = error_messages.join.html_safe
      error_list = content_tag(:ul, error_list).html_safe
      content_tag(:div, error_list, class: 'ui error message')
    else
      ''
    end
  end
end
