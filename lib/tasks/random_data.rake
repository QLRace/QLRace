namespace :db do
  desc 'Insert Random data into DB'
  task random_data: :environment do
    maps = %w(campgrounds trinity skyward overlord infinity theedge jumpwerkz)
    500.times do |p_id|
      name = Faker::Internet.user_name
      4.times do |mode|
        Score.new_score(maps.sample, mode, p_id, rand(1000..140_000), SecureRandom.uuid, name)
      end
    end
    puts 'Done.'
  end
end
