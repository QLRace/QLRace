# frozen_string_literal: true

namespace :db do
  desc 'Fix world records after times have been deleted.'
  task fix_world_records: :environment do
    Rails.application.eager_load!
    require 'ruby-progressbar'

    WorldRecord.transaction do
      WorldRecord.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('world_records')
      maps = Score.uniq.pluck(:map).sort
      progress = ProgressBar.create(total: maps.length * 4)
      maps.each do |map|
        (0..3).each do |mode|
          progress.increment
          s = Score.where(map: map, mode: mode).order(:time, :updated_at).first
          next if s.nil?

          WorldRecord.create!(s.attributes.except('id'))
        end
      end
    end
  end
end
