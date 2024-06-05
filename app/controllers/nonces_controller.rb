class NoncesController < ApplicationController
  skip_before_action :check_signed_in, only: [:show]

  def show
    unless EthAddressValidator.eth_address?(params[:address])
      render json: { errors: 'Provide a valid wallet address' }, status: :unprocessable_entity
      return
    end

    render json: { nonce: NonceService.new(params[:address]).generate }
  end
end
