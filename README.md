# Mini Credit Line Backend

A real-time USDC credit line system with on-chain synchronization.

## Overview

This project implements a tiny version of a complete credit line system where users can draw (borrow) and repay USDC in real-time, with state synchronized to blockchain smart contracts.

## What It Does

A user connects their wallet, and the backend provides them with a credit limit (similar to a credit card limit). They can then:

- **Draw (Borrow)** - Borrow USDC up to their credit limit
- **Repay** - Pay back what they borrowed
- **Track State** - See their loan state update in real-time via API and webhooks
- **On-Chain Sync** - Backend listens to smart contract events and automatically syncs state

## Architecture

This is a **monorepo** with the following workspaces:

- **`apps/api`** - Fastify REST API server
- **`apps/worker`** - BullMQ worker for background jobs and webhooks
- **`apps/chain`** - Blockchain event listener and sync service
- **`apps/contracts`** - Hardhat smart contracts
- **`packages/shared`** - Shared types and utilities

## Tech Stack

- **TypeScript** with ES modules
- **Fastify** - Fast web framework
- **PostgreSQL** - Database
- **BullMQ** + **Redis** - Job queue
- **Hardhat** - Smart contract development
- **Ethers.js** - Blockchain interaction
- **Docker Compose** - Local database setup

## Getting Started

### Prerequisites

- Node.js 18+
- Docker and Docker Compose
- Redis (for worker queue)

### Installation

```bash
# Install all dependencies
npm install

# Start PostgreSQL
npm run db

# Run development servers
npm run dev      # API server
npm run worker   # Background worker
npm run chain    # Chain sync service
```

### Available Scripts

- `npm run dev` - Start API server
- `npm run worker` - Start background worker
- `npm run chain` - Start chain event listener
- `npm run db` - Start Docker PostgreSQL
- `npm run db:down` - Stop Docker PostgreSQL
- `npm test` - Run tests (all workspaces)
- `npm run lint` - Lint code (all workspaces)

### Smart Contracts

```bash
# From apps/contracts
npm run compile  # Compile contracts
npm run test     # Run contract tests
npm run node     # Run local Hardhat node
npm run deploy   # Deploy contracts
```

## Project Structure

```
MiniCreditline/
├── apps/
│   ├── api/          # REST API server
│   ├── worker/       # Background jobs
│   ├── chain/        # Blockchain sync
│   └── contracts/    # Smart contracts
├── packages/
│   └── shared/       # Shared code
├── docker-compose.yml
└── package.json      # Workspace config
```

## Environment Variables

Create `.env` files in each app directory:

### apps/api/.env
```
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/creditline
REDIS_URL=redis://localhost:6379
```

### apps/worker/.env
```
REDIS_URL=redis://localhost:6379
DATABASE_URL=postgresql://user:password@localhost:5432/creditline
```

### apps/chain/.env
```
RPC_URL=http://localhost:8545
DATABASE_URL=postgresql://user:password@localhost:5432/creditline
```

## Features

- ✅ Real-time credit line management
- ✅ USDC draw and repay operations
- ✅ Webhook notifications for state changes
- ✅ On-chain event synchronization
- ✅ PostgreSQL for persistent state
- ✅ Background job processing with BullMQ
- ✅ TypeScript with strict mode
- ✅ Monorepo architecture with npm workspaces

## License

ISC

## Author

Arsh Bansal
