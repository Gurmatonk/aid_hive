module ConversationsHelper
  def message_list(receipts)
    message_groups = receipts.each_with_object([[receipts.first.message.sender, []]]) do |receipt, memo|
      group = memo.last
      if group.first == receipt.message.sender
        group.last << receipt.message
      else
        memo << [receipt.message.sender, [receipt.message]]
      end
    end
    capture do
      content_tag :div, class: 'panel panel-default' do
        content_tag :div, class: 'panel-body' do
          content_tag :div, class: 'messags' do
            message_groups.each do |sender, messages|
              concat(content_tag(:div, class: :media) do
                # code for profile images if decided to add any
                # concat(content_tag(:div, class: 'media-left') do
                #  content_tag :a, href: '#' do
                #    image_tag 'http://placehold.it/64x64', class: 'media-object'
                #  end
                #end)
                concat(content_tag(:div, class: 'media-body') do
                  concat(content_tag(:h5, class: 'media-heading') do
                    link_to messages.first.sender.name, messages.first.sender
                  end)
                  messages.each do |message|
                    concat(content_tag :small, "#{l(message.created_at, format: :message)}: ", class: 'text-muted')
                    concat message.body
                    concat(tag(:br)) unless message == messages.last
                  end
                end)
              end)
            end
          end
        end
      end
    end
  end
end
