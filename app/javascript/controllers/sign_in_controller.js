import { Controller } from '@hotwired/stimulus';
import { createConfig, watchAccount, connect, getWalletClient } from '@wagmi/core';
import { http, UserRejectedRequestError } from 'viem'
import { metaMask } from '@wagmi/connectors';
import { mainnet } from '@wagmi/core/chains'

export default class extends Controller {
  static targets = [
    'status',
    'form',
    'addressInput',
    'signatureInput',
    'messageInput',
    'metamaskButton'
  ];

  connect() {
    this.config = createConfig({
      chains: [mainnet],
      transports: {
        [mainnet.id]: http(),
      },
    });

    watchAccount(this.config, {
      onChange: (account) => {
        if (account.status === 'connected') {
          this.statusTarget.textContent = `Connected to ${account.address}`;
          this.signMessage(account.address);
        } else if (account.status === 'connecting') {
          this.statusTarget.textContent = `Connecting...`;
        } else if (account.status === 'disconnected') {
          this.statusTarget.textContent = `Not connected`;
        }
      },
    })
  }

  async connectMetaMask(event) {
    event.preventDefault();
    await connect(this.config, {
      chainId: mainnet.id,
      connector: metaMask()
    });
  }

  async signMessage(address) {
    this.metamaskButtonTarget.disabled = true
    const client = await getWalletClient(this.config);
    const nonceResponse = await fetch(`/nonces/${address}`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'GET',
    }).then((response) => response.json());

    if (client) {
      this.statusTarget.textContent = 'Requesting signature...';
      try {
        const message = `Sign this message to sign in\nNonce:\n${nonceResponse.nonce}`
        const signature = await client.signMessage({
          account: address.toLowerCase(),
          message
        });
        this.statusTarget.textContent = 'Signing in';
        this.addressInputTarget.value = address;
        this.signatureInputTarget.value = signature;
        this.messageInputTarget.value = message;
        this.formTarget.submit();
      } catch (e) {
        if (e instanceof UserRejectedRequestError) {
          this.statusTarget.textContent = 'Rejected';
          this.metamaskButtonTarget.disabled = false
        } else {
          throw e;
        }
      }
    }
  }
}
