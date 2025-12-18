CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  wallet_address TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ledger_events (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  type TEXT NOT NULL,               -- "CREDIT_LIMIT_SET" | "DRAW" | "REPAY"
  amount_cents BIGINT NOT NULL,
  idempotency_key TEXT,
  tx_hash TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ledger_user_time ON ledger_events(user_id, created_at);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_user_idempotency
  ON ledger_events(user_id, idempotency_key)
  WHERE idempotency_key IS NOT NULL;