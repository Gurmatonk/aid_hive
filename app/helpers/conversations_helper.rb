module ConversationsHelper
  def message_list(receipts)
    message_groups = group_messages(receipts)
    capture do
      current_date = nil
      message_groups.each do |_sender, messages|
        add_date_separator(current_date, messages.first.created_at)
        current_date = messages.first.created_at
        concat(content_tag(:div, class: :media) do
          # code for profile images if decided to add any
          # concat(content_tag(:div, class: 'media-left') do
          #  content_tag :a, href: '#' do
          #    image_tag 'http://placehold.it/64x64', class: 'media-object'
          #  end
          # end)
          concat(content_tag(:div, class: 'media-body') do
            concat(content_tag(:h5, class: 'media-heading') do
              link_to_if messages.first.sender != current_user, messages.first.sender.name, messages.first.sender
            end)
            messages.each do |message|
              render_message(message, current_date, message == messages.last)
              current_date = message.created_at
            end
          end)
        end)
      end
    end
  end

  def group_messages(receipts)
    receipts.each_with_object([[receipts.first.message.sender, []]]) do |receipt, memo|
      group = memo.last
      if group.first == receipt.message.sender
        group.last << receipt.message
      else
        memo << [receipt.message.sender, [receipt.message]]
      end
    end
  end

  def render_message(message, current_date, is_last_message)
    add_date_separator(current_date, message.created_at)
    concat(content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'col-md-auto') do
        concat(content_tag :small, "#{l(message.created_at, format: :time)}: ", class: 'text-muted')
      end)
      concat(content_tag(:div, class: 'col-md-auto') do
        concat auto_link(text_with_line_breaks(message.body))
      end)
      concat(tag(:br)) unless is_last_message
    end)
  end

  def add_date_separator(last_date, current_date)
    return if last_date.try(:to_date) == current_date.to_date
    concat(content_tag(:strong, l(current_date.to_date, format: :with_weekday)))
  end
end
