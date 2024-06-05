class User < ApplicationRecord
  validates :address, presence: true, uniqueness: true, eth_address: { allow_blank: true }
end
