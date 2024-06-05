class NonceService
  NONCE_NAMESPACE = 'web3_login:nonce:'.freeze

  attr_reader :address

  def initialize(address)
    @address = address&.downcase
  end

  def generate
    nonce = SecureRandom.uuid
    REDIS.setex("#{NONCE_NAMESPACE}#{address}", 5.minutes.to_i, nonce)
    nonce
  end

  def get
    REDIS.get("#{NONCE_NAMESPACE}#{address}")
  end

  def unset
    REDIS.del("#{NONCE_NAMESPACE}#{address}")
  end
end
