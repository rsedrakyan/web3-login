require 'rails_helper'

RSpec.describe NoncesController, type: :controller do
  describe 'GET #show' do
    context 'with a valid Ethereum address' do
      let(:valid_address) { '0x0000000000000000000000000000000000000000' }
      let(:nonce) { SecureRandom.hex }

      before do
        allow_any_instance_of(NonceService).to receive(:generate).and_return(nonce)
        get :show, params: { address: valid_address }
      end

      it 'returns a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the nonce in the response' do
        expect(JSON.parse(response.body)).to eq('nonce' => nonce)
      end
    end

    context 'with an invalid Ethereum address' do
      let(:invalid_address) { 'invalid_address' }

      before do
        get :show, params: { address: invalid_address }
      end

      it 'returns a 422 status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message in the response' do
        expect(JSON.parse(response.body)).to eq('errors' => 'Provide a valid wallet address')
      end
    end
  end
end
