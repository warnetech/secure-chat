# Server

The server component is responsible for:

- Storing encrypted message ciphertext only.
- Storing and distributing public keys as needed.
- Relaying messages between clients over WebSockets.
- Managing connectivity and message delivery infrastructure.

Security requirements:

- The server must never have access to plaintext message content.
- The server must never perform message decryption.
- The server must never log message content.
- All message payloads should be treated as opaque ciphertext.
