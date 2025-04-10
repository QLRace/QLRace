# frozen_string_literal: true

module Api
  class MapsApiController < Api::ApiController
    resource_description do
      resource_id "Maps"
    end

    api :GET, "/maps", "List of all maps"
    param :sort, ["alphabetical", "recent"], desc: "Default is alphabetical"
    def maps
      maps = if params[:sort] == "recent"
        Score.order(:created_at).pluck(:map).uniq.reverse
      else
        WorldRecord.order(:map).distinct(:map).pluck(:map)
      end
      render(json: { maps: maps })
    end
  end
end
