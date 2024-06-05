require 'rails_helper'

RSpec.describe NonceService do
  let(:address) { '0xb794f5ea0ba39494ce839613fffba74279579268' }
  let(:nonce) { SecureRandom.uuid }

  before do
    # Clear Redis before each test
    $redis.flushdb
  end

  describe '#get' do
    subject { described_class.new(address).get }

    context 'when nonce exists' do
      before do
        $redis.set("#{NonceService::NONCE_NAMESPACE}#{address}", nonce)
      end

      it 'returns the existing nonce' do
        expect(subject).to eq(nonce)
      end
    end

    context 'when nonce does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#generate' do
    subject { described_class.new(address).generate }

    it 'sets an expiration time for the nonce' do
      new_nonce = subject
      ttl = $redis.ttl("#{NonceService::NONCE_NAMESPACE}#{address}")
      expect(ttl).to be > 0
      expect(ttl).to be <= 5.minutes.to_i
    end
  end

  describe '#unset' do
    subject { described_class.new(address).unset }

    before do
      $redis.set("#{NonceService::NONCE_NAMESPACE}#{address}", nonce)
    end

    it 'clears the nonce' do
      subject
      expect($redis.get("#{NonceService::NONCE_NAMESPACE}#{address}")).to be_nil
    end
  end
end
