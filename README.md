# MDCoin (MDC)

A SIP-010 compliant fungible token smart contract built on the Stacks blockchain using Clarity.

## Overview

MDCoin is a fungible token that implements the SIP-010 standard, providing a secure and standardized way to create, transfer, and manage digital tokens on the Stacks blockchain. The contract includes comprehensive functionality for token operations including transfers, minting, burning, and metadata management.

## Features

- ✅ **SIP-010 Compliant**: Fully implements the SIP-010 fungible token standard
- 🔒 **Secure**: Authorization checks for privileged operations
- 💰 **Initial Supply**: 1 billion MDC tokens (1,000,000,000.000000 with 6 decimals)
- 🔥 **Burn Capability**: Users can burn their own tokens
- ⚡ **Mint Capability**: Contract owner can mint new tokens
- 📝 **Metadata**: Configurable token URI for metadata
- 🎯 **Read-Only Functions**: Query balances, supply, and token information

## Token Details

- **Name**: MDCoin
- **Symbol**: MDC
- **Decimals**: 6
- **Initial Supply**: 1,000,000,000.000000 MDC (1,000,000,000,000,000 base units)
- **Token URI**: https://mdcoin.io/token-metadata.json

## Smart Contract Functions

### Public Functions

#### `transfer`
```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```
Transfers tokens from sender to recipient. Sender must be the transaction sender.

**Parameters:**
- `amount`: Amount of tokens to transfer (in base units)
- `sender`: Principal sending the tokens (must be tx-sender)
- `recipient`: Principal receiving the tokens
- `memo`: Optional memo (max 34 bytes)

**Returns:** `(response bool uint)`

**Errors:**
- `u100`: Unauthorized (sender is not tx-sender)
- `u102`: Invalid amount (amount must be > 0)

---

#### `mint`
```clarity
(mint (amount uint) (recipient principal))
```
Mints new tokens to a recipient. Only callable by contract owner.

**Parameters:**
- `amount`: Amount of tokens to mint
- `recipient`: Principal to receive minted tokens

**Returns:** `(response bool uint)`

**Errors:**
- `u100`: Unauthorized (caller is not contract owner)
- `u102`: Invalid amount (amount must be > 0)

---

#### `burn`
```clarity
(burn (amount uint))
```
Burns tokens from the caller's balance.

**Parameters:**
- `amount`: Amount of tokens to burn

**Returns:** `(response bool uint)`

**Errors:**
- `u102`: Invalid amount (amount must be > 0)

---

#### `set-token-uri`
```clarity
(set-token-uri (new-uri (string-utf8 256)))
```
Updates the token URI. Only callable by contract owner.

**Parameters:**
- `new-uri`: New token URI (max 256 characters)

**Returns:** `(response bool uint)`

**Errors:**
- `u100`: Unauthorized (caller is not contract owner)

---

### Read-Only Functions

#### `get-name`
```clarity
(get-name)
```
Returns the token name.

**Returns:** `(response (string-ascii 24) uint)` - "MDCoin"

---

#### `get-symbol`
```clarity
(get-symbol)
```
Returns the token symbol.

**Returns:** `(response (string-ascii 10) uint)` - "MDC"

---

#### `get-decimals`
```clarity
(get-decimals)
```
Returns the number of decimals.

**Returns:** `(response uint uint)` - `u6`

---

#### `get-balance`
```clarity
(get-balance (account principal))
```
Returns the token balance of an account.

**Parameters:**
- `account`: Principal to query

**Returns:** `(response uint uint)` - Balance in base units

---

#### `get-total-supply`
```clarity
(get-total-supply)
```
Returns the total token supply.

**Returns:** `(response uint uint)` - Total supply in base units

---

#### `get-token-uri`
```clarity
(get-token-uri)
```
Returns the token URI.

**Returns:** `(response (optional (string-utf8 256)) uint)`

---

#### `get-contract-owner`
```clarity
(get-contract-owner)
```
Returns the contract owner principal.

**Returns:** `(response principal uint)`

---

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| `u100` | `ERR_UNAUTHORIZED` | Caller is not authorized for this operation |
| `u101` | `ERR_INSUFFICIENT_BALANCE` | Insufficient token balance |
| `u102` | `ERR_INVALID_AMOUNT` | Invalid amount (must be > 0) |

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v3.10.0 or higher
- Node.js (for TypeScript tests)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mdcoin.git
cd mdcoin
```

2. Install dependencies:
```bash
npm install
```

### Testing

#### Check contract syntax:
```bash
clarinet check
```

#### Run tests:
```bash
npm test
```

#### Run Clarinet console:
```bash
clarinet console
```

### Project Structure

```
mdcoin/
├── contracts/
│   └── mdcoin.clar          # Main token contract
├── tests/
│   └── mdcoin.test.ts       # TypeScript tests
├── settings/
│   ├── Devnet.toml          # Devnet configuration
│   ├── Testnet.toml         # Testnet configuration
│   └── Mainnet.toml         # Mainnet configuration
├── Clarinet.toml            # Project configuration
├── package.json             # Node.js dependencies
├── tsconfig.json            # TypeScript configuration
├── vitest.config.ts         # Vitest test configuration
└── README.md                # This file
```

## Deployment

### Devnet
```bash
clarinet integrate
```

### Testnet/Mainnet
```bash
clarinet deployments generate --testnet
# or
clarinet deployments generate --mainnet
```

Then follow the Clarinet deployment instructions.

## Usage Examples

### Transfer Tokens
```clarity
(contract-call? .mdcoin transfer u1000000 tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM none)
```

### Check Balance
```clarity
(contract-call? .mdcoin get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Burn Tokens
```clarity
(contract-call? .mdcoin burn u500000)
```

### Mint Tokens (Owner Only)
```clarity
(contract-call? .mdcoin mint u1000000000 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

## Security Considerations

- The contract owner has privileged access to mint new tokens and update the token URI
- Users can only transfer their own tokens (enforced by checking `tx-sender`)
- All public functions include proper validation and authorization checks
- Token amounts must be greater than zero for all operations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For support, please open an issue in the GitHub repository.

## Acknowledgments

- Built with [Clarinet](https://github.com/hirosystems/clarinet)
- Follows the [SIP-010 Fungible Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
- Deployed on [Stacks Blockchain](https://www.stacks.co/)
 
