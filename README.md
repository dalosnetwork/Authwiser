# Authwiser
Platform that enables multi-wallet management using the AUTH and AUTHCALL opcodes recommended in EIP3074.

Authwiser is a wallet management platform that utilizes the features introduced by EIP-3074 or EIP-7702, expected to come with the Ethereum Pectra update. The primary goal of Authwiser is to allow users (individuals or institutions) with multiple wallets to manage all their wallets through a single platform for transactions on Ethereum.

Users can connect their wallets to the Authwiser platform and authorize another wallet to perform transactions with their signature or perform transactions with the signature of a wallet they have been authorized by. Additionally, users can check the status of the authorizations they have granted and revoke them if necessary.

Due to the differences between EIP-3074 and EIP-7702, the method of wallet management through Authwiser will vary depending on which EIP is included in the Pectra update.

# EIP-3074
If EIP-3074 is included in the Pectra update, two new opcodes, auth and authcall, will be added to the EVM.

Authwiser will enable users to manage their wallets via a smart contract that executes the auth and authcall opcodes.

# EIP-7702
EIP-7702 adds a new input called contract_code to the signing process, allowing EOA wallets to act like smart contracts. This way, wallets that are authorized or have been given authorization can be managed through a smart contract. Authwiser will leverage the contract_code feature to enable users to manage their wallets.
