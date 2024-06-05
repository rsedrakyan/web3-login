require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates presence of address' do
    user = build(:user, address: nil)
    user.validate
    expect(user.errors[:address]).to include("can't be blank")
  end

  it 'validates uniqueness of address' do
    create(:user, address: '0x0000000000000000000000000000000000000000')
    user = build(:user, address: '0x0000000000000000000000000000000000000000')
    user.validate
    expect(user.errors[:address]).to include('has already been taken')
  end

  describe 'eth_address validation' do
    it 'adds an error for invalid address' do
      user = build :user, address: 'invalid_address'
      user.validate
      expect(user.errors[:address]).to include('is not a valid address')
    end

    it 'accepts a valid address' do
      user = build :user
      user.validate
      expect(user.errors[:address]).to be_empty
    end
  end
end
