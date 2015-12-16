namespace :db do
  desc 'Insert Random data into DB'
  task random_data: :environment do
    t = Time.now
    maps = %w(campgrounds trinity skyward overlord infinity theedge jumpwerkz)
    Score.transaction do
      500.times do |p_id|
        name = Faker::Internet.user_name
        4.times do |mode|
          score = { map: maps.sample, mode: mode, player_id: p_id,
                    time: rand(600..160_000), match_guid: SecureRandom.uuid,
                    name: name }
          Score.new_score(score)
        end
      end
    end
    puts 'Done.'
    puts "Inserting data took #{Time.now - t} seconds."
  end
end
