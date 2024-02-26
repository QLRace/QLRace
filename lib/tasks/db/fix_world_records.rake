# frozen_string_literal: true

namespace :db do
  desc "Fix world records after times have been deleted."
  task fix_world_records: :environment do
    Rails.application.eager_load!
    require "ruby-progressbar"

    WorldRecord.transaction do
      WorldRecord.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!("world_records")
      maps = Score.distinct.pluck(:map).sort
      progress = ProgressBar.create(total: maps.length * 4) # standard:disable Rails/SaveBang
      maps.each do |map|
        4.times do |mode|
          progress.increment
          s = Score.where(map: map, mode: mode).order(:time, :updated_at).first
          next if s.nil?

          WorldRecord.create!(
            s.attributes.except("id",
              "checkpoints",
              "speed_start",
              "speed_end",
              "speed_top",
              "speed_average")
          )
        end
      end
    end
  end
end
