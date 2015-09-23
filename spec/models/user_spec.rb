require 'rails_helper'

describe User do
  before do
    @user = User.new(:username => 'Joe_user', :email => 'joe@example.com',
                     :admin => false, :password => 'password', :password_confirmation => 'password')
  end
  subject { @user }

  it { should respond_to :username }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :admin }

  describe 'validation' do
    it { should be_valid }

    context 'when username is blank' do
      before { @user.username = ' ' }
      it { should_not be_valid }
    end

    context "when username or email is already taken" do
      before do
        user_with_same_username = @user.dup
        user_with_same_username.save
      end

      it { should_not be_valid }
    end

    context 'when password is too short' do
      before { @user.password = 'a' }
      it { should_not be_valid }
    end

    context 'when password and confirmation do not match' do
      before { @user.password_confirmation = 'passdorw' }
      it { should_not be_valid }
    end

    context 'when password is missing' do
      before { @user.password = '' }
      it { should_not be_valid }
    end

    context 'when password confirmation is missing' do
      before { @user.password_confirmation = '' }
      it { should_not be_valid }
    end
  end
end
