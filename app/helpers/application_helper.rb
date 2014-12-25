module ApplicationHelper
  def render_errors(model)
    error_messages = model.errors.full_messages.map do |message|
      content_tag(:li, message)
    end
    if error_messages.any?
      content_tag(:ul, error_messages.join.html_safe, class: 'errors')
    end
  end
end
