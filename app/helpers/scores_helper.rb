# frozen_string_literal: true

module ScoresHelper
  def mode_string(mode)
    mode_strings = ['PQL Weapons', 'PQL Strafe', 'VQL Weapons',
                    'VQL Strafe']
    mode_strings[mode]
  end

  def mode_params(mode)
    params = [{}, { weapons: 'false' }, { physics: 'vql', weapons: 'true' },
              { physics: 'vql', weapons: 'false' }]
    params[mode]
  end
end
