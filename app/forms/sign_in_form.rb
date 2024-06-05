require 'eth'

class SignInForm < BaseForm
  ATTRS = [:address, :signature, :message].freeze

  attr_accessor(*ATTRS)

  validates :signature, :message, presence: true
  validate :check_signature, if: -> { address.present? && signature.present? && message.present? }

  def initialize(attributes = {})
    return if attributes.blank?

    @address = attributes[:address]&.downcase
    @signature = attributes[:signature]
    @message = attributes[:message].gsub("\r\n", "\n")
  end

  def submit
    valid? && process
  end

  def valid?
    super

    # Add order errors
    user.validate
    errors.merge!(user.errors)

    errors.none?
  end

  def reset
    ATTRS.each { |attr| public_send("#{attr}=", nil) }
  end

  private

  def process
    nonce_service.unset

    user.last_sign_in_at = Time.current
    user.save
  end

  def check_signature
    nonce = nonce_service.get
    if nonce.nil? || !message.ends_with?(nonce)
      errors.add(:signature, 'is not valid')
      return
    end

    signature_pubkey = Eth::Signature.personal_recover message, signature
    signature_address = Eth::Util.public_key_to_address signature_pubkey

    return if signature_address.to_s.downcase == address

    errors.add(:signature, 'is not valid')
  end

  def user
    @user ||= User.find_or_initialize_by(address:)
  end

  def nonce_service
    @nonce_service ||= NonceService.new(address)
  end
end
