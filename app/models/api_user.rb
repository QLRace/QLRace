# == Schema Information
#
# Table name: api_users
#
#  id                  :bigint           not null, primary key
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string
#  email               :string           default(""), not null
#  encrypted_password  :string           default(""), not null
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_api_users_on_email  (email) UNIQUE
#
class ApiUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable,
    :token_authenticatable

  has_many :authentication_tokens
end
