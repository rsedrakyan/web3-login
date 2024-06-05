require 'rails_helper'

RSpec.describe SignInForm do
  let(:valid_attributes) do
    {
      address: '0x0000000000000000000000000000000000000000',
      signature: 'valid_signature',
      message: "Sign this message to sign in\nNonce:\nvalid_nonce",
    }
  end

  describe '#initialize' do
    context 'with valid attributes' do
      it 'sets the attributes properly' do
        form = SignInForm.new(valid_attributes)
        expect(form.address).to eq(valid_attributes[:address])
        expect(form.signature).to eq(valid_attributes[:signature])
        expect(form.message).to eq(valid_attributes[:message])
      end

      it 'converts message line endings' do
        valid_attributes[:message] = "Sign this message to sign in\r\nNonce:\r\nvalid_nonce"
        form = SignInForm.new(valid_attributes)
        expect(form.message).to eq("Sign this message to sign in\nNonce:\nvalid_nonce")
      end
    end
  end

  describe '#submit' do
    context 'with valid attributes and successful processing' do
      it 'returns true' do
        allow_any_instance_of(NonceService).to receive(:get).and_return('valid_nonce')
        allow(Eth::Signature).to receive(:personal_recover).and_return('pubkey')
        allow(Eth::Util).to receive(:public_key_to_address).and_return(valid_attributes[:address])

        form = SignInForm.new(valid_attributes)
        allow(form).to receive(:process).and_return(true)
        expect(form.submit).to be(true)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { address: '', signature: '', message: '' } }

      it 'returns false' do
        form = SignInForm.new(invalid_attributes)
        expect(form.submit).to be(false)
      end
    end
  end

  describe '#valid?' do
    context 'with valid attributes' do
      it 'is valid' do
        allow_any_instance_of(NonceService).to receive(:get).and_return('valid_nonce')
        allow(Eth::Signature).to receive(:personal_recover).and_return('pubkey')
        allow(Eth::Util).to receive(:public_key_to_address).and_return(valid_attributes[:address])

        form = SignInForm.new(valid_attributes)
        expect(form).to be_valid
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { address: '', signature: '', message: '' } }

      it 'is invalid' do
        form = SignInForm.new(invalid_attributes)
        expect(form).not_to be_valid
      end
    end
  end

  describe '#reset' do
    let(:form) { SignInForm.new(valid_attributes) }

    it 'resets the attributes' do
      form.reset
      expect(form.address).to be_nil
      expect(form.signature).to be_nil
      expect(form.message).to be_nil
    end
  end
end
