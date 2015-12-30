namespace :db do
  desc 'Fix world records after times have been deleted.'
  task fix_world_records: :environment do
    Score.distinct(:map).pluck(:map).each do |map|
      (0..3).each do |mode|
        s = Score.where(map: map, mode: mode).order(:time, :updated_at).first_or_initialize
        insert_world_record(s)
      end
    end
  end
end

def insert_world_record(score)
  wr = WorldRecord.where(map: score.map, mode: score.mode).first_or_initialize

  if score.time.nil?
    wr.delete if wr.time.present?
  elsif wr.time != score.time || wr.player_id != score.player_id
    wr.time = score.time
    wr.player_id = score.player_id
    wr.updated_at = score.updated_at
    wr.api_id = score.api_id
    wr.match_guid = score.match_guid
    wr.save!
  end
end
