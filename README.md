# Solcipher-APTOS 🛡️ On-Chain Encryption for Aptos

**The first symmetric encryption module built natively in Move for the Aptos blockchain.**

Encrypt messages, private data, stealth addresses, encrypted NFTs, dark pool orders, or any sensitive payload directly on-chain — fully verifiable, immutable, and owned by the user.

- Pure Move implementation (no external crates needed for basic version)  
- Upgradable to ChaCha20-Poly1305 & AES-GCM (examples included)  
- Resource-based storage → impossible to duplicate or fake ownership  
- Works today on Aptos mainnet & testnet  

🚀 **Live contract on Aptos mainnet coming in the next 5 minutes after you deploy it**

## Why Solcipher Exists

Most "private" data on blockchains today is just base64-encoded or obscured — still readable by anyone.  
Solcipher lets you store data that is **truly encrypted on-chain** and only the key holder can decrypt it.

Use cases:
- Encrypted messaging dApps
- Stealth addresses & private transfers
- Dark pool trading
- Soul-bound tokens with hidden metadata
- Medical records, KYC, or legal records that must stay private forever

## Quick Start (3 commands)

```bash
# 1. Clone
git clone https://github.com/yourusername/Solcipher-APTOS.git
cd Solcipher-APTOS

# 2. Compile & test
aptos move test          # → All tests pass
aptos move compile

# 3. Publish to Aptos testnet/mainnet
apt  
