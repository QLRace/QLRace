# frozen_string_literal: true

require 'rails_helper'

DATES = [Time.utc(2021, 4, 17), Time.utc(2021, 4, 17, 19),
         Time.utc(2021, 4, 22), Time.utc(2021, 4, 24, 18),
         Time.utc(2021, 4, 24, 19, 1), Time.utc(2021, 4, 26),
         Time.utc(2021, 5, 1, 17, 59, 59), Time.utc(2021, 5, 1, 18, 30),
         Time.utc(2021, 5, 5), Time.utc(2021, 5, 10), Time.utc(2021, 5, 16),
         Time.utc(2021, 5, 22, 18)].freeze

RSpec.describe Qlwc do
  let(:qlwc) { described_class.new }

  describe 'current_map' do
    it 'returns nil if time is before qlwc21 started' do
      expect(qlwc.current_map(Time.utc(2021, 4, 13))).to be_nil
    end

    it 'returns the current map' do
      results = [nil, 'qlwc21_round0', 'qlwc21_round0', nil,
                 'qlwc21_round1', 'qlwc21_round1', 'qlwc21_round1', nil,
                 'qlwc21_round2', 'qlwc21_round3', 'qlwc21_round4', nil]
      DATES.zip(results).each do |date, result|
        # puts "#{date} #{result}"
        expect(qlwc.current_map(date)).to eq(result)
      end
    end
  end

  describe 'round_active?' do
    it 'returns false if map is not a qlwc map' do
      expect(qlwc.round_active?('trinity', DATES[0])).to eq(false)
    end

    it 'returns false if round 0 has not started' do
      expect(qlwc.round_active?('qlwc21_round0', DATES[0])).to eq(false)
    end

    it 'returns true if round 1 is active' do
      expect(qlwc.round_active?('qlwc21_round1', DATES[5])) == true
    end
  end

  describe 'round_started?' do
    it 'returns false if round 0 has not started' do
      expect(qlwc.round_started?('qlwc21_round0', DATES[0])).to eq(false)
    end

    it 'returns true if round 0 has started' do
      expect(qlwc.round_started?('qlwc21_round0', DATES[1])).to eq(true)
    end
  end

  describe 'round_finished?' do
    it 'returns false if round 1 has not finished' do
      expect(qlwc.round_finished?('qlwc21_round1', DATES[5])).to eq(false)
    end

    it 'returns true if round 1 has finished' do
      expect(qlwc.round_finished?('qlwc21_round1', DATES[7])).to eq(true)
    end
  end

  describe 'hidden_maps' do
    it 'returns all maps if round 0 has not finished' do
      expect(qlwc.hidden_maps(DATES[0])).to eq(Qlwc::MAPS)
    end

    it 'returns round1-round4 if round 1 has finished' do
      result = Qlwc::MAPS[1..]
      expect(qlwc.hidden_maps(DATES[4])).to eq(result)
    end

    it 'returns empty array if round 4 has finished' do
      expect(qlwc.hidden_maps(DATES[11])).to eq([])
    end
  end
end
