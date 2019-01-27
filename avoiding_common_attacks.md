# Avoiding Common Attacks

1. *Logic Bugs:* Avoided overly complex rules to prevent `Logic Bugs` in the merchandise smart contract

2. *Tx.Origin Problem:* Not using tx.origin at all

3. *Malicious Actions:* Used `isAdmin` modifier to prevent malicious actions by privileged participants in the marketplace. Only contract owner can configure contract pausability OR permanent perishing of contract. However, Multisig approach is in the roadmap to limit the power.