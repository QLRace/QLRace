# frozen_string_literal: true

# QLWC 2021

# Round0 by Eksha and Kool-Aid
# Available to play: April 17th at 18:00 UTC
# Start: April 17th at 19:00 UTC
# End: April 24th at 18:00 UTC

# Round1 by mui
# Available to play: April 24th at 18:00 UTC
# Start: April 24th at 19:00 UTC
# End: May 1st at 18:00 UTC

# Round2 by Torp
# Available to play: May 1st at 18:00 UTC
# Start: May 1st at 19:00 UTC
# End: May 8th at 18:00 UTC

# Round3 by Eksha
# Available to play: May 8th at 18:00 UTC
# Start: May 8th at 19:00 UTC
# End: May 15th at 18:00 UTC

# Round4 by Kool-Aid
# Available to play: May 15th at 18:00 UTC
# Start: May 15th at 19:00 UTC
# End: May 22th at 18:00 UTC

class Qlwc
  MAPS = %w[qlwc21_round0 qlwc21_round1 qlwc21_round2
            qlwc21_round3 qlwc21_round4].freeze
  START_DATES = [Time.utc(2021, 4, 17, 19), Time.utc(2021, 4, 24, 19),
                 Time.utc(2021, 5, 1, 19), Time.utc(2021, 5, 8, 19),
                 Time.utc(2021, 5, 15, 19)].freeze
  END_DATES = [Time.utc(2021, 4, 24, 18), Time.utc(2021, 5, 1, 18),
               Time.utc(2021, 5, 8, 18), Time.utc(2021, 5, 15, 18),
               Time.utc(2021, 5, 22, 18)].freeze

  def current_map(time)
    return nil if time < START_DATES[0] || time >= END_DATES[4]

    MAPS.each_with_index do |map, round|
      return map if time >= START_DATES[round] && time < END_DATES[round]
    end

    nil
  end

  def round_active?(map, time)
    round = MAPS.find_index(map)
    return false if round.nil?

    time >= START_DATES[round] && time < END_DATES[round]
  end

  def round_started?(map, time)
    round = MAPS.find_index(map)
    return false if round.nil?

    time >= START_DATES[round]
  end

  def round_finished?(map, time)
    round = MAPS.find_index(map)
    return false if round.nil?

    time >= END_DATES[round]
  end

  def hidden_maps(time)
    hidden = []
    MAPS.each do |map|
      hidden << map unless round_finished?(map, time)
    end
    hidden
  end
end
