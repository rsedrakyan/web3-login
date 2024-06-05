require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:valid_attributes) { { address: 'valid_address' } }
  let(:invalid_attributes) { { address: nil } }
  let(:sign_in_form) { instance_double('SignInForm') }

  before do
    allow(SignInForm).to receive(:new).and_return(sign_in_form)
  end

  describe 'GET #new' do
    context 'when user is not signed in' do
      it 'returns a successful response' do
        allow(controller).to receive(:user_signed_in?).and_return(false)
        get :new
        expect(response).to be_successful
      end
    end

    context 'when user is signed in' do
      it 'redirects to root path' do
        allow(controller).to receive(:user_signed_in?).and_return(true)
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      before do
        allow(sign_in_form).to receive(:submit).and_return(true)
        allow(sign_in_form).to receive(:address).and_return('valid_address')
      end

      it 'sets the user session' do
        post :create, params: { sign_in_form: valid_attributes }
        expect(session[:user_address]).to eq('valid_address')
      end

      it 'redirects to the root path' do
        post :create, params: { sign_in_form: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      before do
        allow(sign_in_form).to receive(:submit).and_return(false)
        allow(sign_in_form).to receive(:reset)
      end

      it 'renders the new template with unprocessable entity status' do
        post :create, params: { sign_in_form: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to the root path' do
      delete :destroy
      expect(response).to redirect_to(new_sessions_path)
    end
  end
end
