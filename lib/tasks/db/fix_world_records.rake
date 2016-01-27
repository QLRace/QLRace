namespace :db do
  desc 'Fix world records after times have been deleted.'
  task fix_world_records: :environment do
    WorldRecord.delete_all
    Score.distinct(:map).pluck(:map).each do |map|
      (0..3).each do |mode|
        s = Score.where(map: map, mode: mode).order(:time, :updated_at).first
        insert_world_record(s) if s
      end
    end
  end
end

def insert_world_record(score)
  WorldRecord.create(score.slice(:map, :mode, :time, :player_id,
                                 :api_id, :updated_at, :match_guid))
end
