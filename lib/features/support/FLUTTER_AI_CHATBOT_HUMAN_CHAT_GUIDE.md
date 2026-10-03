# Flutter Guide: AI Chatbot + Human Chat (Walima)

This guide is based on your current codebases:
- Backend: `walima-engine`
- Frontend reference: `walima-frontend-new`

It explains how to implement in Flutter:
1. AI Support Bot chat (with human escalation ticket)
2. Human-to-human direct chat

---

## 1) Base URLs and Auth

From current code:
- REST base: `{{API_BASE}}/api/v1`
- Socket base: `{{SOCKET_BASE}}`
- AI bot socket namespace: `/support-bot`
- Human chat socket namespace: `/app`

Example (dev):
- `API_BASE = http://localhost:4000`
- `SOCKET_BASE = http://localhost:4000`

All protected routes/sockets require user JWT:
- Header: `Authorization: Bearer <token>`
- Socket auth: send token in `auth.token`

---

## 2) API Envelope (Important)

Backend uses a global response wrapper.

Typical success shape:
```json
{
  "code": "SUCCESS",
  "message": "...",
  "response": { },
  "traceId": "..."
}
```

In Flutter, read from `response` field (not root object directly).

---

## 3) AI Chatbot (Support Bot)

## 3.1 REST endpoints

### Create or resume conversation
`POST /support-bot/conversations`

Returns:
```json
{
  "id": "uuid",
  "status": "active",
  "language": null,
  "createdAt": "...",
  "lastMessageAt": "..."
}
```

### Get conversation list
`GET /support-bot/conversations?page=1&size=20`

### Get messages/history
`GET /support-bot/conversations/:id?page=1&size=50`

### Send message (queue-based)
`POST /support-bot/conversations/:id/messages`
Body:
```json
{ "content": "I need help with payment" }
```

Current backend behavior is **asynchronous**:
- Immediate response means "queued"
- Final bot answer comes by socket event (`support-bot:done`)

Queued response example:
```json
{
  "finalText": "",
  "escalated": false,
  "ticketId": null,
  "needsConfirmation": null,
  "blocked": null,
  "queued": true,
  "jobId": "123",
  "messageId": "uuid"
}
```

### Confirm pending tool action
`POST /support-bot/conversations/:id/confirm`
Body:
```json
{ "toolCallId": "tool-call-id" }
```

### Escalate to human support
`POST /support-bot/conversations/:id/escalate`

Returns:
```json
{ "escalated": true, "ticketId": "uuid" }
```

### Ticket APIs
- `GET /support-bot/tickets?page=1&size=20`
- `GET /support-bot/tickets/:id`
- `DELETE /support-bot/tickets/:id`
- `POST /support-bot/tickets/:id/messages` body: `{ "content": "..." }`

## 3.2 Support bot socket events

Connect to namespace: `/support-bot`

Client emit:
- `support-bot:join` with `{ conversationId }`
- `support-bot:send` with `{ conversationId, content }`

Server emits:
- `support-bot:connected`
- `support-bot:queued`
- `support-bot:done`
- `support-bot:error`
- `support-bot:escalated`

`support-bot:done` payload (key fields):
```json
{
  "userId": "...",
  "conversationId": "...",
  "messageId": "...",
  "jobId": "...",
  "finalText": "assistant reply",
  "escalated": false,
  "ticketId": null,
  "needsConfirmation": null,
  "blocked": null
}
```

## 3.3 Flutter flow (recommended)

1. Create/resume conversation on chat screen open.
2. Connect support-bot socket with JWT.
3. Emit `support-bot:join`.
4. On send:
   - Optimistically show user message in UI.
   - Call REST send endpoint or emit `support-bot:send`.
   - Show sending/processing state until `support-bot:done`.
5. On `support-bot:done`:
   - Append assistant message (`finalText`).
   - If `needsConfirmation != null`, show confirm/cancel buttons.
   - If `escalated == true`, move user into ticket/human-support UI.
6. On `support-bot:error`: show retry UI and allow resend.

---

## 4) Human-to-Human Chat

## 4.1 REST endpoints

### Get chat users/conversations
`GET /chat/conversations`

### Get messages for conversation
`GET /chat/conversations/:conversationId/messages?limit=50&cursor=...`

### Send message
`POST /chat/send-message`
Body (from current DTO):
```json
{
  "receiverId": "uuid",
  "message": "Hello",
  "messageType": "text",
  "mediaId": "optional-uuid",
  "mediaUrl": "optional",
  "fileName": "optional",
  "fileSize": 12345,
  "metadata": {}
}
```

### Message status APIs
- `POST /chat/message/:messageId/mark-delivered`
- `POST /chat/message/:messageId/mark-read`
- `POST /chat/conversation/:conversationId/mark-read`

### Safety actions
- `POST /chat/users/:userId/block`
- `POST /chat/users/:userId/unblock`
- `POST /chat/users/:userId/report`
- `GET /chat/blocked-users`

### Presence REST
- `GET /socket/online-users`
- `GET /socket/user-status/:userId`

## 4.2 Human chat socket events

Connect to namespace: `/app`

Client emit:
- `message:send`
- `typing:start`
- `typing:stop`
- `message:delivered`
- `message:read`
- `conversation:read`
- `users:get-online`
- `users:get-online-connections`

Server emits:
- `connection:success`
- `connection:error`
- `message:received`
- `message:sent`
- `message:error`
- `message:status`
- `typing:indicator`
- `users:online:update`
- `notification:new`
- `notification:received`

## 4.3 Flutter flow (recommended)

1. Load `GET /chat/conversations` for sidebar/inbox.
2. Connect `/app` socket after login.
3. Open conversation -> load messages REST first.
4. Send message using socket `message:send` (or REST fallback).
5. On `message:received`, append to message list.
6. When message becomes visible on screen -> emit `message:delivered`.
7. When user opens thread/read point -> emit `message:read` or `conversation:read`.
8. For typing UX:
   - emit `typing:start` on input activity
   - debounce and emit `typing:stop`
   - render `typing:indicator` from peer

---

## 5) Suggested Flutter Project Structure

```text
lib/
  core/
    network/
      api_client.dart
      auth_interceptor.dart
    socket/
      socket_manager.dart
  features/
    support_bot/
      data/
        support_bot_api.dart
        support_bot_socket.dart
      domain/
        support_bot_models.dart
      presentation/
        support_bot_screen.dart
    human_chat/
      data/
        human_chat_api.dart
        human_chat_socket.dart
      domain/
        chat_models.dart
      presentation/
        chat_list_screen.dart
        chat_room_screen.dart
```

---

## 6) Flutter pseudo code snippets

## 6.1 Shared API client (Dio)

```dart
final dio = Dio(BaseOptions(baseUrl: '$apiBase/api/v1'));

dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await tokenStore.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  },
));
```

## 6.2 Socket connect (socket_io_client)

```dart
final socket = io(
  '$socketBase/support-bot',
  OptionBuilder()
    .setTransports(['polling', 'websocket'])
    .setAuth({'token': token})
    .enableForceNew()
    .setPath('/socket.io')
    .build(),
);
```

## 6.3 AI send + listen

```dart
await dio.post('/support-bot/conversations/$conversationId/messages', data: {
  'content': text,
});

socket.on('support-bot:done', (payload) {
  final finalText = payload['finalText'] as String? ?? '';
  // append assistant message
});
```

## 6.4 Human send + status

```dart
appSocket.emit('message:send', {
  'receiverId': peerId,
  'message': text,
  'messageType': 'text',
});

appSocket.on('message:received', (payload) {
  // append incoming message
});

appSocket.emit('message:read', {'messageId': messageId});
```

---

## 7) Edge Cases You Should Handle

- Token expired on socket connect -> reconnect after token refresh.
- REST success but socket disconnected -> reconcile by reloading history.
- Duplicate message insert (socket + REST refresh) -> dedupe by `message.id`.
- Support-bot queue delay -> show "AI is thinking..." state.
- `blocked: "moderation"` / `blocked: "budget"` on bot response -> show clear UI message.
- Escalation path -> switch to ticket thread UX.

---

## 8) Quick Integration Checklist

- Configure `API_BASE`, `SOCKET_BASE` in Flutter env.
- Implement JWT storage and request/socket auth injection.
- Build Support Bot module:
  - Create/resume conversation
  - History load
  - Queue send + socket done/error handling
  - Escalation + ticket APIs
- Build Human Chat module:
  - Conversation list
  - Thread pagination
  - Realtime send/receive
  - Delivered/read/typing events
  - Block/report actions
- Add retry/reconnect + local dedupe.

---

## 9) Source references used

Backend:
- `walima-engine/src/main.ts`
- `walima-engine/src/support-bot/controllers/support-bot.controller.ts`
- `walima-engine/src/support-bot/gateways/support-bot.gateway.ts`
- `walima-engine/src/support-bot/services/support-bot-queue.service.ts`
- `walima-engine/src/support-bot/processors/support-bot-message.processor.ts`
- `walima-engine/src/chat/controllers/chat.controller.ts`
- `walima-engine/src/chat/gateways/app.gateway.ts`
- `walima-engine/src/chat/controllers/socket.controller.ts`
- `walima-engine/src/chat/dto/send-message.dto.ts`

Frontend reference:
- `walima-frontend-new/.env.example`
- `walima-frontend-new/src/services/socket/socket-client.ts`
- `walima-frontend-new/src/services/socket/support-bot-socket.ts`
- `walima-frontend-new/src/services/api/support-bot.ts`
- `walima-frontend-new/src/actions/chat.action.ts`
