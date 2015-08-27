# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  admin                  :boolean          default(FALSE)
#

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

  it { should be_valid }

  describe 'when username is blank' do
    before { @user.username = ' ' }
    it { should_not be_valid }
  end
  describe "when username or email is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.save
    end

    it { should_not be_valid }
  end
  describe 'when password is too short' do
    before { @user.password = 'a' }
    it { should_not be_valid }
  end
  describe 'when password and confirmation do not match' do
    before { @user.password_confirmation = 'passdorw' }
    it { should_not be_valid }
  end
end
