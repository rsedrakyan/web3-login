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
    subject { build(:user) } # Ensure address is unique for uniqueness validation

    it 'adds an error for invalid eth_address' do
      subject.address = 'invalid_address'
      subject.validate
      expect(subject.errors[:address]).to include('is not a valid address')
    end

    it 'accepts a valid eth_address' do
      subject.validate
      expect(subject.errors[:eth_address]).to be_empty
    end
  end
end
