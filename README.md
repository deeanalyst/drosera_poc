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

## ⚙️ How It Works

### `collect()`

This function gathers structured data from each block, including:

- `trackedAddress`: The wallet being watched
- `tokenBalance`: Current token balance of the tracked address
- `price`: Current Chainlink price
- `blockTimestamp` and `blockNumber`: Temporal context
- `operator`: The node/operator collecting the data

### `shouldRespond()`

This function:

- Compares the most recent 2 collected data points
- Checks if:
  - The tracked address's token balance changed beyond a defined threshold
  - The price feed shifted more than allowed
- If both are true, and the trap is still `active`, it returns `true` and triggers the `respondWithERC20Context(...)` function

Only addresses on the whitelist can operate this trap.

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

### ⚙️ `drosera.toml`
Configuration and deployment of the Drosera trap and response system targeting ERC-20 whale activity.

````markdown
ethereum_rpc = "https://eth-hoodi.g.alchemy.com/v2/-AXQAagLYU0TtShg7SXdBLPNyAVQI1uI"
drosera_rpc = "https://relay.hoodi.drosera.io"
eth_chain_id = 560048
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]

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
address = "0x21ef0984CFda7c9A784A6B2515e8a6656220df86"
````

---

🧪 Status
✅ Contracts deployed

✅ Forge-compatible

🔶 Not yet tested in a live trap trigger scenario

🔧 Tuning may still be needed (e.g., thresholds, response logic)

🧭 Lessons Learned
This project helped me:

- Gain a solid understanding of Drosera's trap–response mechanism.

- Improve proficiency with Forge, Solc, and CLI-based workflows.

- Integrate onchain data like price feeds and ERC-20 balances.

- Encode/decode structs in Solidity securely.

- Explore the power of decentralized coordination primitives.

---

💡 Future Enhancements
🪪 SBTs for Responders
- Let participants mint soulbound tokens (non-transferable NFTs) when they respond to a trap.

⚪ Dynamic Whitelisting
- Use Drosera’s opt-in mechanism to whitelist trusted responders in real time.

📊 Onchain Metadata Storage
- Enhance transparency and auditability by recording granular metadata permanently onchain.

---

🧵 Special Note
This repo is part of my learning journey toward earning Sergeant or Captain status on Drosera. It’s not just about deploying contracts—it's about:

Growth • Learning • Contribution

---

📢 Follow my journey: [@dee__analyst](https://x.com/dee__analyst)
🌐 Learn more about the network: [@DroseraNetwork](https://x.com/DroseraNetwork)
