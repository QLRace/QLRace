# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  api_key    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  before_validation :set_api_key
  validates_presence_of :api_key

  def set_api_key
    self.api_key = SecureRandom.base64.tr('+/=', 'Qrt')
  end
end
