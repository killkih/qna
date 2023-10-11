# frozen_string_literal: true

module ApplicationHelper
  def display_buttons(resource)
    'hidden' if current_user.voted?(resource)
  end

  def hide_buttons(resource)
    'hidden' unless current_user.voted?(resource)
  end

  def flash_message(argument)
    return unless flash[argument].present?

    content_tag :div, flash[argument], class: "flash #{argument}"
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
