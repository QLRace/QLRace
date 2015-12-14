require "administrate/base_dashboard"

class ScoreDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    player: Field::BelongsTo,
    id: Field::Number,
    map: Field::String,
    mode: Field::Number,
    time: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    match_guid: Field::String.with_options(searchable: false),
    api_id: Field::Number,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :player,
    :id,
    :map,
    :mode,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :player,
    :map,
    :mode,
    :time,
    :match_guid,
    :api_id,
  ]

  # Overwrite this method to customize how scores are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(score)
  #   "Score ##{score.id}"
  # end
end
