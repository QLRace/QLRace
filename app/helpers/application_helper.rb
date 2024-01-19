# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def full_title(title = "")
    base_title = "QLRace"
    title.empty? ? base_title : "#{title} | #{base_title}"
  end

  def time_string(milli)
    return "-" if milli == 2_147_483_647 || milli.nil? || milli.zero?

    time = milli.to_i
    s, ms = time.divmod(1000)
    ms = format("%03d", ms)
    return "#{s}.#{ms}" if s < 60

    m, s = s.divmod(60)
    s = format("%02d", s)
    "#{m}:#{s}.#{ms}"
  end
end
