require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe 'validations' do
    # Cannot test presence or inclusion of booleans due to database behavior
    # Presence of user_id not needed due to belongs_to assoc.
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:cheers) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end
end
