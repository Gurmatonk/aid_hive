module ApplicationHelper
  def t_navigation(key)
    t key, scope: [:views, :navigation, :requests]
  end

  def text_with_line_breaks(text)
    text.gsub("\n", '<br/>').html_safe
  end

  def subnav_link_to(active, link_target, link_text = '')
    content_tag(:li, class: active ? 'active' : '') do
      link_to link_target do
        if block_given?
          yield
        else
          concat link_text
        end
      end
    end
  end

  def navbar_menu(active, name)
    content_tag(:li, class: 'dropdown' + (active ? ' active' : '')) do
      concat(link_to('#', class: 'dropdown-toggle',  'data-toggle' => 'dropdown', role: 'button', 'aria-haspopup' => true, 'aria-expanded' => false) do
        concat name
        concat ' '
        concat tag(:span, class: 'caret')
      end)
      concat(content_tag(:ul, class: 'dropdown-menu') do
        yield
      end)
    end
  end

  def icon_link(icon, target, tooltip, html_options = {})
    link_to(target, html_options) do
      icon_image icon, tooltip
    end
  end

  def icon_image(icon, tooltip = '', extra_css_class = '', html_options = {})
    content_tag :span, '', html_options.merge(class: "glyphicon glyphicon-#{icon} #{extra_css_class}", title: tooltip, rel: 'tooltip')
  end

end
