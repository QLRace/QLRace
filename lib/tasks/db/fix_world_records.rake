namespace :db do
  desc 'Fix world records after times have been deleted.'
  task fix_world_records: :environment do
    WorldRecord.transaction do
      WorldRecord.delete_all
      Score.uniq.pluck(:map).each do |map|
        (0..3).each do |mode|
          s = Score.where(map: map, mode: mode).order(:time, :updated_at).first
          WorldRecord.create!(s.attributes) if s
        end
      end
    end
  end
end
