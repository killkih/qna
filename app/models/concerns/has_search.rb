module HasSearch
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
    after_save :reindex
  end


  private

  def reindex
    PgSearch::Multisearch.rebuild(self.class)
  end
end


