-- secure-chat Phase 1 schema for Cloudflare D1 (SQLite).
-- Stores public keys and encrypted message data only. No plaintext.

CREATE TABLE IF NOT EXISTS users (
  id            TEXT PRIMARY KEY,
  username      TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at    TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS devices (
  id                TEXT PRIMARY KEY,
  user_id           TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  registration_id   INTEGER NOT NULL,
  identity_key      BLOB NOT NULL,
  signed_prekey_id  INTEGER NOT NULL,
  signed_prekey     BLOB NOT NULL,
  signed_prekey_sig BLOB NOT NULL,
  created_at        TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS one_time_prekeys (
  device_id   TEXT NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  id          INTEGER NOT NULL,
  public_key  BLOB NOT NULL,
  used        INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (device_id, id)
);

CREATE TABLE IF NOT EXISTS messages (
  id                  TEXT PRIMARY KEY,
  client_message_id   TEXT NOT NULL,
  sender_device_id    TEXT NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  recipient_device_id TEXT NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  ciphertext          BLOB NOT NULL,
  created_at          TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  delivered_at        TEXT,
  UNIQUE (sender_device_id, client_message_id)
);

CREATE INDEX IF NOT EXISTS messages_recipient_idx
  ON messages (recipient_device_id, created_at);
