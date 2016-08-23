namespace :db do
  desc 'Fix world records after times have been deleted.'
  task fix_world_records: :environment do
    WorldRecord.transaction do
      WorldRecord.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('world_records')
      Score.uniq.pluck(:map).sort.each do |map|
        (0..3).each do |mode|
          s = Score.where(map: map, mode: mode).order(:time, :updated_at).first
          next if s.nil?
          WorldRecord.create!(s.attributes.except('id'))
          puts "Inserted record for #{map}, mode #{mode}."
        end
      end
    end
  end
end
