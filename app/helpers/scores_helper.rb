module ScoresHelper
  def mode_string(mode)
    mode_strings = ['Turbo Weapons', 'Turbo Strafe', 'Classic Weapons',
                    'Classic Strafe']
    mode_strings[mode]
  end

  def mode_params(mode)
    params = [{}, { weapons: 'false' }, { factory: 'classic', weapons: 'true' },
              { factory: 'classic', weapons: 'false' }]
    params[mode]
  end
end
