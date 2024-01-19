# frozen_string_literal: true

module ScoresHelper
  def mode_string(mode)
    mode_strings = [ "PQL Weapons", "PQL Strafe", "VQL Weapons",
                    "VQL Strafe" ]
    mode_strings[mode]
  end
end
