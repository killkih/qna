require 'rails_helper'

RSpec.describe SearchService do
  it 'calls for all resources' do
    expect(PgSearch).to receive(:multisearch).with('test')
    SearchService.new('test', 'All').call
  end

  it 'calls for single resource' do
    %w[Question Answer Comment User].each do |resource|
      expect(resource.constantize).to receive(:search).with('test')
      SearchService.new('test', resource).call
    end
  end
end
