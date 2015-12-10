# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  map        :string           not null
#  mode       :integer          not null
#  player_id  :bigint           not null
#  time       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_guid :uuid             not null
#  api_id     :integer
#

require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end
end
