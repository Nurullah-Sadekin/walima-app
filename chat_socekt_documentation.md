This documentation provides a comprehensive guide for integrating real-time messaging and notifications into the **Walima** mobile ecosystem. By leveraging a hybrid approach of **Socket.IO** for low-latency interactions and **REST** for data persistence, the system ensures a responsive and reliable user experience.

---

## 1. Architectural Overview
The system utilizes a dual-channel communication strategy:
* **WebSockets (Socket.IO):** Handles high-frequency, real-time events such as instant messages, typing indicators, and live presence.
* **REST API:** Acts as the "Source of Truth" for historical data, initial state hydration, and recovering from offline periods.



### Why this approach?
A REST-only polling strategy is avoided to prevent high battery consumption and "jagged" UI updates. The WebSocket connection allows the server to **push** updates to the client the moment they occur.

---

## 2. Connection Specifications

| Detail | Specification |
| :--- | :--- |
| **Protocol** | Socket.IO (v4.x recommended) |
| **Namespace** | `/app` |
| **Base WebSocket URL** | `http://dev.walima.app/app` |
| **Base REST URL** | `http://dev.walima.app/api` |
| **Authentication** | JWT passed via `auth.token` during handshake |
| **Transports** | `websocket`, `polling` |

### Connection Lifecycle
1.  **Handshake:** Client initiates connection with a valid JWT.
2.  **Validation:** Server validates the token and joins the client to a private room: `user:<userId>`.
3.  **Confirmation:** Server emits `connection:success`.
4.  **Presence:** Server broadcasts `users:online:update` to all relevant peers.

---

## 3. Event Contract

### Client → Server (Outbound)
These events are emitted by the mobile application to trigger actions on the backend.

| Event | Payload | Purpose |
| :--- | :--- | :--- |
| `message:send` | `{ receiverId, message, messageType }` | Dispatch a new chat message. |
| `typing:start` | `{ receiverId, conversationId? }` | Notify peer of active typing. |
| `typing:stop` | `{ receiverId, conversationId? }` | Clear the typing indicator. |
| `message:read` | `{ messageId }` | Confirm the user has viewed the message. |
| `notification:subscribe`| `(None)` | Subscribe the socket to the notification room. |

### Server → Client (Inbound)
The mobile app must listen for these events to update the UI dynamically.

| Event | Category | Purpose |
| :--- | :--- | :--- |
| `message:received` | Chat | A peer has sent a message to the user. |
| `message:status` | Chat | Updates on delivery/read status of sent messages. |
| `typing:indicator` | Chat | Visual cue that a peer is currently typing. |
| `users:online:update` | Presence | Real-time changes in friend/contact availability. |
| `notification:new` | Notifications| Push-style data for in-app alerts. |

---

## 4. Message Reliability & Lifecycle
To ensure no messages are lost during network transitions, follow this sequence:

1.  **Optimistic UI:** When the user sends a message, render it immediately in a "Pending" state.
2.  **Server ACK:** Wait for the `message:sent` event. Once received, update the message status to "Sent."
3.  **Peer ACK:** Listen for `message:status` updates. When `status == 'delivered'` or `'read'`, update the UI indicators accordingly.



> **Note on Delta Sync:** Upon reconnecting after a signal drop, the client should query the REST API for all messages since the `last_received_timestamp` to fill any "gaps" that occurred while the socket was closed.

---

## 5. Security & Best Practices

* **Token Rotation:** If the JWT expires, the socket must be disconnected and re-initialized with the new token. Do not attempt to reuse an old handshake.
* **Idempotency:** Always use Client-Generated UUIDs for messages. This prevents duplicate messages if a "retry" is triggered during a network flicker.
* **Room Logic:** Notifications are delivered via `notifications:<userId>`. Always ensure `notification:subscribe` is called immediately after a successful `connection:success` event.
* **Validation:** Treat all incoming payloads as untrusted. Validate the data structure before passing it to the UI layer to prevent crashes from malformed JSON.

---

This documentation serves as the blueprint for the mobile implementation. Adhering to these patterns will ensure a scalable, "real-time first" experience for Walima users.

Does this structure align with how you plan to organize the technical requirements for the team?