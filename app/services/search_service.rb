# frozen_string_literal: true

class SearchService

  def initialize(query, resource)
    @query = query
    @resource = resource
  end

  def call
    @resource == 'All' ? PgSearch.multisearch(@query) : @resource.constantize.search(@query)
  end
end
