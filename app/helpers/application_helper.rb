module ApplicationHelper
  def render_errors(model)
    error_messages = model.errors.full_messages.map do |message|
      content_tag(:li, message)
    end
    error_lis = error_messages.join.html_safe
    content_tag(:ul, error_lis, class: 'errors') if error_messages.any?
  end
end
