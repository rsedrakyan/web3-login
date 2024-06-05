require 'eth'

class EthAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if (value.blank? && options[:allow_blank?]) || EthAddressValidator.eth_address?(value)

    record.errors.add(attribute, options[:message] || 'is not a valid address')
  end

  def self.eth_address?(value)
    Eth::Address.new(value).valid?
  rescue Eth::Address::CheckSumError
    false
  end
end
