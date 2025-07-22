![cover](https://pbs.twimg.com/profile_banners/1692652226068520960/1736263723/1080x360)

# 🪤 ERC20WhaleTrap — A Custom Drosera Trap

This project is a proof-of-concept trap designed for the [Drosera Network](https://app.drosera.io), created as part of my exploration into trap-building, event responses, and onchain participation mechanisms.

It combines an ERC-20 balance tracker with price feed deviation detection, and it triggers an external response contract when whale-like behavior is observed.

## 🧠 Concept

The `ERC20WhaleTrap` monitors a specified ERC-20 token for:
- Significant balance increases or decreases.
- Unusual deviations in Chainlink price feeds.

If both thresholds are crossed, it calls the `ERC20WhaleResponse` contract to emit a verifiable log.

This system could later be extended to:
- Record identities.
- Mint SBTs (soulbound tokens) as immutable participation proofs.
- Reward vigilant actors who contribute to decentralized security.

---

## 🛠️ Smart Contracts

### 🔐 `ERC20WhaleTrap.sol`
- **Monitors** token balance and price movement.
- **Triggers** only if thresholds are breached.
- **Deployed at:** `0x579796F48dC44a6E46c18e0D9B97364bf55a3EF1`

### ⚡ `ERC20WhaleResponse.sol`
- Receives data from the trap.
- Emits contextual logs (like address, balance, and price shift).
- **Deployed at:** `0x45Fcba9D589602d9a321feA71BF364DB2dabbB78`

---

## ⚙️ drosera.toml Configuration

```toml
[traps.mytrap]
path = "out/ERC20WhaleTrap.sol/ERC20WhaleTrap.json"
response_contract = "0x45Fcba9D589602d9a321feA71BF364DB2dabbB78"
response_function = "respondWithERC20Context(address,uint256,uint256,int256,int256)"
cooldown_period_blocks = 33
min_number_of_operators = 1
max_number_of_operators = 2
block_sample_size = 1
private = true
whitelist = []

🧪 Status
✅ Contracts deployed
✅ Forge-compatible
🔶 Not yet tested in a live trap trigger scenario
🔧 Some tuning may be needed (e.g. thresholds, response logic)

🧭 Lessons Learned
This project helped me:

➤ Understand how Drosera's trap–response system works.

➤ Use forge, solc, and command-line tooling confidently.

➤ Work with price feeds, ERC-20 balances, and Solidity struct encoding.

➤ Appreciate how onchain coordination systems can be composed securely.

💡 Future Ideas
➤ Allow participants to mint SBTs after a trap is triggered.

➤ Whitelist responders dynamically using drosera opt-in.

➤ Store more granular metadata on-chain.

🧵 Special Note
This project is part of my journey to earn the Sergeant or Captain roles on Drosera. It's not just about smart contracts, but the spirit of learning and contribution.

Follow me [@dee__analyst](https://x.com/dee__analyst) for updates and reflections or more info about the [@DroseraNetwork](https://x.com/DroseraNetwork).
