class User < ActiveRecord::Base
  before_validation :set_api_key
  validates :api_key, presence: true

  def set_api_key
    self.api_key = SecureRandom.base64.tr('+/=', 'Qrt')
  end
end
