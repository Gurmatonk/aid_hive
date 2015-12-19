module ApplicationHelper
  def within_options(selected)
    options = [[t_view(:query_within_any), 47_058]] + [5, 10, 20, 25, 30, 50, 75, 100].map { |value| ["#{value} km", value] }
    options_for_select(options, selected)
  end

  def t_view(key, options = {})
    # FIXME: Lazy fix for existing calls like t_view(:some_key, :some_scope) - or feature as shortcut without interpolations
    options = {scope: options} unless options.is_a?(Hash)
    t_scoped_with_common_fallback key, :views, [controller.controller_name, controller.action_name], options
  end

  def t_scoped_with_common_fallback(key, application_scope, default_nested_scope, options)
    application_scope = [application_scope] unless application_scope.is_a?(Array)
    options.reverse_merge!(scope: default_nested_scope)
    options[:scope] = [options[:scope]] unless options[:scope].is_a?(Array)
    options[:scope] = application_scope + options[:scope]
    options[:scope] = (application_scope + [:common]) unless I18n.exists?(options[:scope] + [key])
    t key, options
  end

  def message_relates_to_entry_hint(entry)
    "#{t_view(:relates_to)}: #{polymorphic_url(entry)}"
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

  def link_with_optional_icon(link_target, link_text, options, icon = nil)
    link_to link_target, options do
      if icon.present?
        concat icon_image(icon)
        concat ' '
      end
      concat("#{link_text}")
    end
  end

  def action_link_to(entity, action, options = {})
    forbidden_behavior = options.delete(:if_forbidden) || :hide
    action_permitted = policy(entity).send("#{action}?")
    return unless action_permitted || forbidden_behavior != :hide
    unless action_permitted
      options[:class] ||= ''
      options[:class] += ' disabled'
    end
    link_target = options.delete(:link_target) || ([:show, :destroy].include?(action.to_sym) ? entity : [action, entity])
    link_text = options.delete(:link_text) || t("actions.#{action}")
    icon = options.delete(:icon)
    options[:data] ||= {confirm: "#{entity.class.model_name.human} wirklich löschen?"} if options[:method] == :delete
    options[:target] = '_blank' if action == :download
    link_with_optional_icon(link_target, link_text, options, icon)
  end

  def action_button(entity, action, options = {})
    action_link_to entity, action, {class: 'btn btn-default'}.merge(options)
  end

  def google_map(addressable, options = {})
    options.reverse_merge! width: 500, height: 500, zoom: 15
    address_line = addressable.address_line
    url_params = [
      ['center', address_line],
      ['markers', address_line],
      ['zoom', options[:zoom]],
      ['size', "#{options[:width]}x#{options[:height]}"],
      %w(sensor false)
    ].map { |p, v| "#{p}=#{v}" }.join('&')
    tag :img, src: "//maps.googleapis.com/maps/api/staticmap?#{url_params}", class: 'img-rounded'
  end
end
