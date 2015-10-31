module ScoresHelper
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
