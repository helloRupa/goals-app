require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(username: 'hi', password: '12345678') }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:session_token) }
    it { should validate_presence_of(:cheers) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:session_token) }
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'associations' do
    it { should have_many(:goals) }
    it { should have_many(:comments) }
    it { should have_many(:commented_goals) }
    it { should have_many(:commented_users) }
    it { should have_many(:comments_from_users) }
  end

  describe 'initialize' do
    context 'when a new user object is initialized' do
      it 'sets the session token' do
        user = User.new
        expect(user.session_token).to_not be_nil
      end
    end
  end

  describe 'attributes' do
    it 'makes the password readable' do
      user = User.new
      user.password = 'hellothere'
      expect(user.password).to eq('hellothere')
    end
  end

  describe 'instance methods' do
    password = 'password'
    subject(:user) { User.new(username: 'jimmy', password: password) }

    context '#password=(pw)' do
      it 'sets the password_digest to a string' do
        expect(user.password_digest).to be_kind_of(String)
      end

      it 'encodes the password for password_digest' do
        expect(user.password_digest).to_not eq(password)
      end

      it 'does not encode the same password into the same string each time' do
        digest = user.password_digest
        user.password = password
        expect(user.password_digest).to_not eq(digest)
      end
    end

    context '#is_password?(pw)' do
      it 'returns true when the provided password matches' do
        expect(user.is_password?(password)).to be(true)
      end

      it 'returns false when the provided password does not match' do
        expect(user.is_password?('hamburger')).to be(false)
      end
    end

    context '#ensure_session_token' do
      it 'ensures the user has a session token' do
        user.ensure_session_token
        expect(user.session_token).to_not be_nil
      end

      it 'does not modify the session token if the user already has one' do
        token = 'cats_in_a_bag'
        user.session_token = token
        user.ensure_session_token
        expect(user.session_token).to eq(token)
      end
    end

    context '#reset_session_token!' do
      it 'issues a new session token to the user' do
        token = user.session_token
        user.reset_session_token!
        expect(user.session_token).to_not eq(token)
      end

      it 'returns the new session token' do
        token = user.reset_session_token!
        expect(user.session_token).to eq(token)
      end

      it 'saves the user with the updated token to the database' do
        u = User.new(username: 'Beans')
        u.password = 'password'
        u.save
        token = u.reset_session_token!
        expect(User.find_by_username('Beans').session_token).to eq(token)
      end
    end
    
    context '#cheer(goal)' do
      let(:goal) { double('Goal', cheers: 0).as_null_object }

      it 'reduces the user\'s cheers by 1' do
        user_cheers = user.cheers
        user.cheer(goal)
        expect(user.cheers).to eq(user_cheers - 1)
      end

      it 'increases the goal\'s cheers by 1' do
        user.cheer(goal)
        expect(goal).to have_received(:cheers=).with(1)
      end
    end
  end

  describe 'class methods' do
    context '::generate_session_token' do
      it 'returns a string' do
        expect(User.generate_session_token).to be_kind_of(String)
      end

      it 'generates a unique string each time it is called' do
        token = User.generate_session_token
        expect(User.generate_session_token).to_not eq(token)
      end
    end

    context '::find_by_credentials(username, password)' do
      username = 'hamtaro'
      password = 'password'

      def make_user(username, password)
        user = User.new(username: username)
        user.password_digest = 'will_be_overwritten' # prevent error when no methods are written
        user.password = password
        user.session_token = 'boggles'
        user.save!
        user.id
      end

      before(:each) do
        User.destroy_all
      end

      it 'returns nil if a matching record is not found' do
        make_user(username, password)
        expect(User.find_by_credentials('ham', '1')).to be_nil
        expect(User.find_by_credentials(username, '1234')).to be_nil
        expect(User.find_by_credentials('ham', password)).to be_nil
      end

      it 'returns the matching record when found' do
        id = make_user(username, password)
        found = User.find_by_credentials(username, password)
        expect(found.id).to eq(id)
      end
    end
  end
end
