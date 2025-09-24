# NECTR Staking Subgraph

A subgraph for indexing events from the NECTR staking contract on Ethereum Sepolia testnet.

## Overview

This subgraph indexes the following events from the staking contract:
- **Staked**: When users stake tokens
- **Withdrawn**: When users withdraw staked tokens
- **RewardsClaimed**: When users claim their rewards
- **EmergencyWithdrawn**: When users perform emergency withdrawals
- **RewardRateUpdated**: When the reward rate is updated
- **StakingInitialized**: When the staking contract is initialized

## Entities

The subgraph tracks the following entities:
- **StakingContract**: Contract-level information
- **User**: Individual user data and statistics
- **Stake**: Individual staking transactions
- **Withdrawal**: Individual withdrawal transactions
- **RewardClaim**: Individual reward claim transactions
- **EmergencyWithdrawal**: Individual emergency withdrawal transactions
- **RewardRateUpdate**: Reward rate change events
- **DailyStats**: Daily aggregated statistics
- **GlobalStats**: Global protocol statistics

## Setup

1. Install dependencies:
```bash
npm install
```

2. Generate types from schema and ABI:
```bash
npm run codegen
```

3. Build the subgraph:
```bash
npm run build
```

## Deployment

### The Graph Studio (Hosted Service)

1. Create a subgraph on [The Graph Studio](https://thegraph.com/studio/)
2. Get your deploy key from the studio
3. Authenticate with the Graph CLI:
```bash
graph auth --studio <DEPLOY_KEY>
```
4. Deploy to studio:
```bash
npm run deploy
```

### Local Graph Node

1. Start a local Graph Node (requires Docker):
```bash
# Clone graph-node repository
git clone https://github.com/graphprotocol/graph-node/
cd graph-node/docker
docker-compose up
```

2. Create the subgraph locally:
```bash
npm run create-local
```

3. Deploy to local node:
```bash
npm run deploy-local
```

## Configuration

The subgraph is configured for:
- **Network**: Sepolia
- **Contract Address**: `0x03149CF87371e7E38714563efAC3E355c0B56752`
- **Start Block**: 7000000 (adjust based on actual deployment block)

## Example Queries

### Get all users with their staking information:
```graphql
{
  users {
    id
    stakedAmount
    totalRewardsClaimed
    lastStakeTimestamp
    stakes {
      amount
      timestamp
    }
  }
}
```

### Get global protocol statistics:
```graphql
{
  globalStats(id: "global") {
    totalStaked
    totalUsers
    totalStakes
    currentRewardRate
    lastUpdated
  }
}
```

### Get daily statistics for the last 7 days:
```graphql
{
  dailyStats(first: 7, orderBy: date, orderDirection: desc) {
    date
    totalStaked
    totalUsers
    totalStakes
    averageStakeAmount
  }
}
```

### Get recent staking events:
```graphql
{
  stakes(first: 10, orderBy: timestamp, orderDirection: desc) {
    user {
      id
    }
    amount
    timestamp
    currentRewardRate
  }
}
```

## Development

To modify the subgraph:

1. Update the schema in `schema.graphql`
2. Update the mapping functions in `src/mapping.ts`
3. Run `npm run codegen` to regenerate types
4. Run `npm run build` to build the subgraph
5. Deploy with `npm run deploy`

## Contract Information

- **Staking Token**: Test ERC20 token for staking
- **Network**: Ethereum Sepolia Testnet
- **Contract Address**: `0x03149CF87371e7E38714563efAC3E355c0B56752`

## Features

- Real-time indexing of all staking events
- User-level statistics and history
- Daily and global aggregated statistics
- Emergency withdrawal tracking
- Reward rate change history
- Comprehensive transaction history

## Support

For issues or questions about this subgraph, please refer to [The Graph documentation](https://thegraph.com/docs/) or create an issue in the repository.# subgraph_project
