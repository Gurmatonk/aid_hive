module ApplicationHelper
  def within_options(selected)
    options = [[t_view(:query_within_any), 47058]] +  [5, 10, 20, 25, 30, 50, 75, 100].map { |value| ["#{value} km", value] }
    options_for_select(options, selected)
  end

  def t_view(key, scope = [controller.controller_name])
    scope = [scope] unless scope.is_a?(Array)
    scope = [:views] + scope
    if I18n.exists?(scope + [key])
      t key, scope: (scope)
    else
      t key, scope: [:views, :common]
    end
  end

  def text_with_line_breaks(text)
    text.gsub("\n", '<br/>').html_safe
  end

  def subnav_link_to(active, link_target, link_text = '', options = {})
    content_tag(:li, class: active ? 'active' : '') do
      link_to link_target, options do
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

  def action_link_to(entity, action, options = {})
    forbidden_behavior = options.delete(:if_forbidden) || :hide
    unless policy(entity).send("#{action}?")
      case forbidden_behavior
      when :disable
        options[:class] ||= ''
        options[:class] += ' disabled'
      when :hide
        return
      end
    end
    link_target = options.delete(:link_target) || ([:show, :destroy].include?(action.to_sym) ? entity : [action, entity])
    link_text = options.delete(:link_text) || t("actions.#{action}")
    icon = options.delete(:icon)
    options[:data] ||= {confirm: "#{entity.class.model_name.human} wirklich löschen?"} if options[:method] == :delete
    options[:target] = '_blank' if action == :download
    link_to(link_target, options) do
      if icon.present?
        concat icon_image(icon)
        concat ' '
      end
      concat("#{link_text}")
    end
  end

  def action_button(entity, action, options = {})
    action_link_to entity, action, {class: 'btn btn-default'}.merge(options)
  end
end
