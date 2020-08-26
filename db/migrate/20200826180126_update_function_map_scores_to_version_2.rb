class UpdateFunctionMapScoresToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_function :map_scores, version: 2, revert_to_version: 1
  end
end
