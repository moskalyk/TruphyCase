# 🏆 TruphyCase 🏆 

A smart contract that represents badges (or trophies) which bootstraps learnings from the ERC721 token standard.

### ** This repo is Experimental and a Work in progress.
This project is an attempt to look at non-transferable badges related to Ethereum Addresses. Unfortunately this does not solve the problem of a user 'being able to give away their private key', however, it is a start at managing 'discrete' units of on-chain reputation. There was create a new standard called [EIP1238](https://github.com/ethereum/EIPs/issues/1238)

Main things to notice about the approach:
* Using exists extensions from the ERC721 standard was means to easily integrate with existing wallet interfaces e.g. ERC721Metadata, ERC721Enumerable.
* Use off-chain signing and on-chain claiming methods to create an easy to use mechanism for the distribution of trophies to users from central issuers (e.g. games, websites, reputation, etc.) and shifting the gas payment and ownership to users paying if they want to claim their trophy.

```
Example
Gas Cost Estimation of Assigning: $0.94708 USD
Gas Cost Estimation of Claiming: $1.022575 USD
```

Note: Aware that other standards exists around reputation which look at more granular efforts like ERC735, but this was an experiment around 'Tokenizing Reputation' as a means to easily without the use of any quantified trust model (e.g. PageRank, Eigentrust) 'cluster users' in communities.

Possible Standard Use
* Non-Fungible and Non-Transferable tokens. An authority (e.g. game, bounty platform, social network) would be able to issue and revoke trophies (based on type). Each trophy represents an abstract representation of some peice of a 'Reputon'. Traditional trophies have been used as a mere signal, carried through time. With blockchain, programmatic and discrete value can be placed on the trophy value for an online identity, whereby value can be calculated along some curve.

### Possible Use Cases. 
* 'Top 10' = Revokable.
* 'Scarce / Unique' = Non-Tradeable. Owned for eterenity.
* 'Progress Based Trophies'

Approaches: Managed as an address in the Metadata of the TokenURI? In a mapping?

User Stories:
* A Game / Operator would create Trophies / Badges within an interface that mints trophies. 

### Off-Chain Claim Flow:
* Users sign a message to 'opt into' receiving trophies / goals within a game as accepting a trophy / badge.
* Game / Authority manages score / progress off chain. 
* Rewards user on chain
* (optional) Users would 'claim' if they get an award

Output:
### TruphCaseJS - Possible uses?
* Mint Trophies based on Operator / Game Owner
* Interface that lists all trophies / Leaderboard.
* Can filter trophies based on game (e.g. range 1-10)
* Can groupby User to view Assigned Badges

TODOs
- [ ] Referencing Specific Trophy: E.g. First Place, can be minted to multiple people, and easily referenced.
- [ ] Enumberable Tests
- [ ] Token Metadata Tests
- [ ] Tests

Reach out or create a PR if you're interested in contributing.