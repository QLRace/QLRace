module ScoresHelper
  def time_string(ms)
    unless ms.present?
      return ''
    end
    time = Integer(ms)
    s, ms = time.divmod(1000)
    ms = String(ms).rjust(3, '0')
    if s < 60
      return "#{s}.#{ms}"
    end
    time /= 1000
    m, s = time.divmod(60)
    s = String(s).rjust(2, '0')
    "#{m}:#{s}.#{ms}"
  end

  def mode_string(mode)
    if mode == 1
      return 'Turbo Strafe'
    elsif mode == 1
      return 'Classic Weapons'
    elsif mode == 1
      return 'Classic Strafe'
    else
      return 'Turbo Weapons'
    end
  end
end
