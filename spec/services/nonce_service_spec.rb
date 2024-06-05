require 'rails_helper'

RSpec.describe NonceService do
  let(:address) { '0xb794f5ea0ba39494ce839613fffba74279579268' }
  let(:service) { described_class.new(address) }

  before do
    # Clear Redis before each test
    REDIS.flushdb
  end

  describe '#get' do
    subject { service.get }

    context 'when nonce exists' do
      before do
        service.generate
      end

      it { is_expected.not_to be_nil }
    end

    context 'when nonce does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '#generate' do
    subject { service.generate }

    it 'sets an expiration time for the nonce' do
      subject
      ttl = REDIS.ttl("#{NonceService::NONCE_NAMESPACE}#{address}")
      expect(ttl).to be_between(0, 5.minutes.to_i)
    end
  end

  describe '#unset' do
    before do
      service.generate
    end

    it 'clears the nonce' do
      service.unset
      expect(service.get).to be_nil
    end
  end
end
