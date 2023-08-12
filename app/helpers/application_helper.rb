# frozen_string_literal: true

module ApplicationHelper

  def display_buttons(resource)
    'hidden' if current_user.voted?(resource)
  end

  def hide_buttons(resource)
    'hidden' unless current_user.voted?(resource)
  end
end
