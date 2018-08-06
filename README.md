# 🏆 TruphyCase 🏆 

### ** This repo is still a work in progress.

Possible Standard around
* Non-Fungible and Non-Transferable tokens. Authority would be issue and revoke trophies (based on type). Each trophy representation an abstract representation of some peice of 'Reputation'.

### Possible Use Cases
* 'Top 10' = Revokable.
* 'Scarce / Unique' = Non-Tradeable. Owned for eterenity.
* 'Progress Based Trophies'

User Stories:
* A Game / Operator would create Trophies / Badges within an interface that mints trophies. These Trophies will be 'top 10' or singular scarce trophy based (for now).
* Users play

Flow:
* Users sign a message to 'opt into' receiving trophies / goals within a game as accepting a trophy / badge.
* Game manages score / progress off chain. 
* Rewards user on chain
* (optional) Users would 'claim' if they get an award

Output:
### TruphCase Interface
* Mint Trophies based on Operator / Game Owner
* Interface that lists all trophies / Leaderboard.
* Can filter trophies based on game (e.g. range 1-10)
* Can groupby User to view Assigned Badges

### TruphyCaseJS Module (Possible?)
* Publish npm Module that can assign users
```
//Returns a boolean to confirm that the trophy has been assigned
async assignTruphy(userAddress, trophyId){}

// Returns a boolean to confirm that the trophy has been assigned
async revokeTruphy(userAddress, trophyId){}

// Return a list of json for the games Trophies
async getGameTruphies(gameId){}

// Return a list of json for the users Trophies
async getUserTruphies(userAddress){}
```