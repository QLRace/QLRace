# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token, if: :json_request?

    private

    def json_request?
      request.format.json?
    end
  end
end
