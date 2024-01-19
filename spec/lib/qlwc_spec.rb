# frozen_string_literal: true

require 'rails_helper'

DATES = [ Time.utc(2021, 4, 17), Time.utc(2021, 4, 17, 19),
         Time.utc(2021, 4, 22), Time.utc(2021, 4, 24, 18),
         Time.utc(2021, 4, 24, 19, 1), Time.utc(2021, 4, 26),
         Time.utc(2021, 5, 1, 17, 59, 59), Time.utc(2021, 5, 1, 18, 30),
         Time.utc(2021, 5, 5), Time.utc(2021, 5, 10), Time.utc(2021, 5, 16),
         Time.utc(2021, 5, 22, 18) ].freeze

RSpec.describe Qlwc do
  describe 'current_map' do
    it 'returns nil if time is before qlwc21 started' do
      qlwc = described_class.new(Time.utc(2021, 4, 13))
      expect(qlwc.current_map).to be_nil
    end

    it 'returns the current map' do
      results = [ nil, 'qlwc21_round0', 'qlwc21_round0', nil,
                 'qlwc21_round1', 'qlwc21_round1', 'qlwc21_round1', nil,
                 'qlwc21_round2', 'qlwc21_round3', 'qlwc21_round4', nil ]
      DATES.zip(results).each do |date, result|
        # puts "#{date} #{result}"
        qlwc = described_class.new(date)
        expect(qlwc.current_map).to eq(result)
      end
    end
  end

  describe 'round_active?' do
    it 'returns false if map is not a qlwc map' do
      qlwc = described_class.new(DATES[0])
      expect(qlwc.round_active?('trinity')).to be(false)
    end

    it 'returns false if round 0 has not started' do
      qlwc = described_class.new(DATES[0])
      expect(qlwc.round_active?('qlwc21_round0')).to be(false)
    end

    it 'returns true if round 1 is active' do
      qlwc = described_class.new(DATES[5])
      expect(qlwc.round_active?('qlwc21_round1')) == true
    end
  end

  describe 'round_started?' do
    it 'returns false if round 0 has not started' do
      qlwc = described_class.new(DATES[0])
      expect(qlwc.round_started?('qlwc21_round0')).to be(false)
    end

    it 'returns true if round 0 has started' do
      qlwc = described_class.new(DATES[1])
      expect(qlwc.round_started?('qlwc21_round0')).to be(true)
    end
  end

  describe 'round_finished?' do
    it 'returns false if round 1 has not finished' do
      qlwc = described_class.new(DATES[5])
      expect(qlwc.round_finished?('qlwc21_round1')).to be(false)
    end

    it 'returns true if round 1 has finished' do
      qlwc = described_class.new(DATES[7])
      expect(qlwc.round_finished?('qlwc21_round1')).to be(true)
    end
  end

  describe 'hidden_maps' do
    it 'returns all maps if round 0 has not finished' do
      qlwc = described_class.new(DATES[0])
      expect(qlwc.hidden_maps).to eq(Qlwc::MAPS)
    end

    it 'returns round1-round4 if round 1 has finished' do
      result = Qlwc::MAPS[1..]
      qlwc = described_class.new(DATES[4])
      expect(qlwc.hidden_maps).to eq(result)
    end

    it 'returns empty array if round 4 has finished' do
      qlwc = described_class.new(DATES[11])
      expect(qlwc.hidden_maps).to eq([])
    end
  end
end
