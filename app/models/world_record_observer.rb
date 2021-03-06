# frozen_string_literal: true

class WorldRecordObserver < ActiveRecord::Observer
  def after_update(_record)
    delete_page_cache 'index.html'
  end

  def after_create(_record)
    delete_page_cache 'index.html'
  end

  private

  def delete_page_cache(page)
    page_file = Rails.public_path.join page
    File.delete(page_file) if File.exist? page_file
  end
end
