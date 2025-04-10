# frozen_string_literal: true

# == Schema Information
#
# Table name: authentication_tokens
#
#  id           :bigint           not null, primary key
#  body         :string
#  expires_in   :integer
#  ip_address   :string
#  last_used_at :datetime
#  user_agent   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  api_user_id  :bigint           not null
#
# Indexes
#
#  index_authentication_tokens_on_api_user_id  (api_user_id)
#  index_authentication_tokens_on_body         (body)
#
# Foreign Keys
#
#  fk_rails_...  (api_user_id => api_users.id)
#
class AuthenticationToken < ApplicationRecord
  belongs_to :api_user
end
