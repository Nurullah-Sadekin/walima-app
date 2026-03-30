Walima Mobile Real-Time Messaging & Notifications (WebSocket + REST)

This document outlines the recommended approach for the mobile team to integrate real-time chat and notifications using the existing Socket.IO gateway, while utilizing REST for history and data recovery.Architectural Rationale

A REST-only polling approach for real-time features presents several disadvantages:
Noticeable delivery delay.
Increased request overhead.
Higher battery usage.
Poor support for typing/presence user experience (UX).
The Walima platform already incorporates WebSocket support specifically designed to address these challenges. Current Server Implementation Details
Gateway: src/chat/gateways/app.gateway.ts
Working Client Example: test-chat-client-dev.html
Transport & Connection
Detail
Specification
Protocol
Socket.IO
Namespace
/app
REST API Base URL
http://dev.walima.app/api
WebSocket URL (Socket.IO)
http://dev.walima.app/app
Authentication
JWT via auth.token during the handshake
Enabled Transports
websocket, polling

Connect Flow (Success)
Client connects to /app with the JWT.
Gateway authenticates the token.
Server joins the user room: user:<userId>.
Server marks the user as online.
Server emits connection:success to the connecting socket.
Server pushes a users:online:update to all accepted connections.
Connect Flow (Failure)
If the JWT is missing or invalid:
Server emits connection:error.
Server then disconnects the socket.
Event Contract    Client -> Server (Emit)
Event
Payload
Purpose
message:send
receiverId: string (UUID), message: string, messageType: string (e.g., text)
Send a new message.
typing:start
receiverId: string (UUID), conversationId?: string (UUID)
Signal the start of typing.
typing:stop
receiverId: string (UUID), conversationId?: string (UUID)
Signal the stop of typing.
message:delivered
{ messageId: string }
Acknowledge message delivery.
message:read
{ messageId: string }
Acknowledge a message has been read.
conversation:read
{ conversationId: string }
Acknowledge an entire conversation has been read.
users:get-online
(None)
Request the list of online users.
users:get-online-connections
(None)
Request connections to hydrate live presence UI.
notification:subscribe
(None)
Subscribe the user to notifications.




Server -> Client (Listen)
Event
Category
Purpose
connection:success
Connection/Auth
Confirms a successful connection.
connection:error
Connection/Auth
Indicates a connection or authentication failure.
message:received
Chat
A message intended for the client has arrived.
message:sent
Chat
Confirmation that an outbound message was processed by the server.
message:status
Chat
Updates on message status (delivered/read).
typing:indicator
Chat
Signals when another user is typing.
users:online:update
Presence
Updates to the online status of users.
notification:new
Notifications
General new notification event.
notification:received
Notifications
Confirmation that a notification was processed by the server.

Recommended Mobile LifecycleApp Boot
Load last known conversations/messages from the local database.
Fetch fresh conversation lists/messages via REST (initial data hydration).
Open the WebSocket connection.
Emit notification:subscribe.
Emit users:get-online-connections to hydrate the live presence UI.
While Connected
Send outgoing chat via message:send.
Show an optimistic message state locally.
Reconcile the local state with message:sent and message:status events.
Show typing state using typing:indicator.
Update online indicators from users:online:update.
On Disconnect/Background
Queue unsent messages locally.
Stop sending typing indicators.
Maintain local unread counters.
On Reconnect
Reconnect the socket using exponential backoff.
Re-emit notification:subscribe.
Re-send queued messages.
Run a REST delta sync for missed history/status updates.
The Role of REST and WebSocket
Technology
Purpose
REST
Paginated history, initial data hydration, catch-up after offline periods, deterministic state repair.
WebSocket
Instant message delivery, live read/delivered updates, typing indicators, online presence, instant notifications.

Reliability Guidance
Use idempotency keys or client message IDs for safe retry mechanisms.
Store the outbound message queue in persistent local storage.
Acknowledge each message lifecycle stage in the UI: sending, sent, delivered, and read.
Always use UUIDs for key identifiers (receiverId, messageId, conversationId).
Security Guidance
Never connect the socket without a valid JWT.
Integrate JWT rotation with the normal authentication flow.
On token refresh, immediately reconnect the socket using the new token.
Treat all incoming socket payloads as untrusted and validate types before rendering in the UI.
Feature Notes
Sending a message is subject to server-side plan feature access enforcement (SEND_MESSAGE).
Presence updates are only broadcast to accepted, authenticated connections.
Notifications are emitted to the following rooms/channels:
user:<userId>
notifications:<userId> (after a successful subscription)
Testing

Use the provided test-chat-client-dev.html to validate the integration:
Connect with a JWT.
Send a message.
Observe message:received / message:sent.
Mark a message as delivered/read and verify the message:status update.
Subscribe to notifications and verify notification:new / notification:received.
Trigger presence updates with multiple users

