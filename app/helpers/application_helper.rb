module ApplicationHelper
  def full_title(title = '')
    base_title = 'QLRace'
    if title.empty?
      base_title
    else
      title + ' | ' + base_title
    end
  end

  def time_string(ms)
    return '-' if ms == 2147483647 || ms.blank?
    time = Integer(ms)
    s, ms = time.divmod(1000)
    ms = String(ms).rjust(3, '0')
    return "#{s}.#{ms}" if s < 60
    time /= 1000
    m, s = time.divmod(60)
    s = String(s).rjust(2, '0')
    "#{m}:#{s}.#{ms}"
  end
end
