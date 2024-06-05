module ApplicationHelper
  def show_error_messages(messages)
    messages_array = Array(messages)
    return if messages_array.empty?

    content_tag('div', class: 'error-messages', 'data-turbo-cache' => false) do
      content_tag('ul') do
        messages_array.collect { |message| concat(content_tag('li', message)) }
      end
    end
  end
end
