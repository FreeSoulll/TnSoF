class SearchesController < ApplicationController
  skip_authorization_check

  SEARCH_CHAPTER = %w[All Question Answer Comment User].freeze

  def index
    @search_chapters = SEARCH_CHAPTER
    return @search_results = [] unless params[:query].present?

    @search_results = search(sanitize_query(params[:query]), params[:chapter])
  end

  private

  def search(query, chapter = '')
    return ThinkingSphinx.search(query) unless chapter.present? && (!SEARCH_CHAPTER.include?(chapter) || chapter != 'All')

    chapter.constantize.search(query)
  end

  def sanitize_query(query)
    ActiveRecord::Base.sanitize_sql_like(query)
  end
end
