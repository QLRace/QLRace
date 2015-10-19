module ScoresHelper
  def time_string(ms)
    if !ms.present? then
      return ''
    end
    time = Integer(ms)
    s, ms = time.divmod(1000)
    ms = String(ms).rjust(3, '0')
    if s < 60 then
        return "#{s}.#{ms}"
    end
    time /= 1000
    m, s = time.divmod(60)
    s = String(s).rjust(2, '0')
    return "#{m}:#{s}.#{ms}"
  end
end
