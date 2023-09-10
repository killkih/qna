# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'linkable'
  it_behaves_like 'commentable'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
end
