# Flutter Didit Identity Verification Guide

This document describes how to implement Walima identity verification in a Flutter app using the existing `walima-engine` backend and the current web frontend flow as the behavioral reference.

The key rule is simple:

- Flutter talks only to the Walima backend.
- The backend talks to Didit.
- Flutter never calls Didit directly with the API key.

---

## 1. What already exists

### Backend

Relevant source files:

- [Verification module](/Users/shuvo/e-babui/walima-engine/src/verification/verification.module.ts)
- [User verification controller](/Users/shuvo/e-babui/walima-engine/src/verification/controllers/verification.controller.ts)
- [Didit webhook controller](/Users/shuvo/e-babui/walima-engine/src/verification/controllers/verification-webhook.controller.ts)
- [Verification service](/Users/shuvo/e-babui/walima-engine/src/verification/services/verification.service.ts)
- [Didit service](/Users/shuvo/e-babui/walima-engine/src/verification/services/didit.service.ts)
- [Didit session entity](/Users/shuvo/e-babui/walima-engine/src/database/entities/didit-verification-session.entity.ts)
- [Didit config](/Users/shuvo/e-babui/walima-engine/src/config/didit.config.ts)

### Frontend reference flow

Relevant source files:

- [Identity verification page](/Users/shuvo/e-babui/walima-frontend-new/src/app/(site)/account/profile/settings/identity-verification/page.tsx)
- [Identity status card](/Users/shuvo/e-babui/walima-frontend-new/src/app/(site)/account/profile/settings/identity-verification/identity-status-card.tsx)
- [Profile widget status sync](/Users/shuvo/e-babui/walima-frontend-new/src/components/frontend/pages/account/profile/dashboard/elements/index.tsx)
- [Async API helper](/Users/shuvo/e-babui/walima-frontend-new/src/hooks/useAsync.hook.ts)

---

## 2. Backend architecture

Walima already has a complete server-side Didit integration.

### User-facing API

The backend exposes these authenticated endpoints under the global prefix `api/v1`:

- `POST /api/v1/verification/session`
- `GET /api/v1/verification/status`
- `GET /api/v1/verification/sessions`

All three require a bearer token from `UserJwtGuard`.

### Webhook API

Didit calls:

- `POST /api/v1/webhook/didit`

This route is public to Didit, but the backend verifies webhook signatures before accepting the payload.

### Database tables

The backend persists session state in:

- `didit_verification_sessions`

And user verification state in the `users` table fields:

- `identityVerificationStatus`
- `isVerified`

---

## 3. Environment variables

The backend reads these Didit-related variables:

- `DIDIT_BASE_URL`
- `DIDIT_APP_ID`
- `DIDIT_API_KEY`
- `DIDIT_WEBHOOK_SECRET`
- `DIDIT_WORKFLOW_ID`
- `DIDIT_CALLBACK_URL`


# DIDIT KYC

# =========================

DIDIT_BASE_URL=https://verification.didit.me
DIDIT_APP_ID=5c4c3b6b-0831-4175-b696-8388c079574d
DIDIT_API_KEY=y539dCzXC9w_P8DOlU9s_O0lu85UUhUxdfSNPOZZe10
DIDIT_WEBHOOK_SECRET=0W77yQeHNTAQ6Jfo06cY2sMR_WrdXNTvKSpFYBCOhdI
DIDIT_WORKFLOW_ID=c1be7ce0-4985-46f8-bf04-a572cd33933a
DIDIT_CALLBACK_URL=http://localhost:3000/account/profile/settings/identity-verification?didit=return
# =========================

Current defaults:

- `DIDIT_BASE_URL` defaults to `https://verification.didit.me`

Important note:

- `DIDIT_APP_ID` exists in config, but the current service code does not use it.

---

## 4. Recommended Flutter integration pattern

For the current Walima codebase, the safest and simplest Flutter implementation is:

1. Use the Walima backend to create a Didit session.
2. Open the returned `verificationUrl` in an in-app browser or webview.
3. Poll Walima `GET /verification/status` after the user returns or taps refresh.
4. Display local Flutter UI based on the backend status.

Do not:

- Call Didit directly from Flutter
- Store Didit API keys in the app
- Treat the mobile UI as the source of truth for verification state

If you later want a native Didit Flutter SDK flow, you will need the backend to expose and persist the Didit `session_token`, which the current backend does not store.

---

## 5. Exact backend API contract

### 5.1 Create session

`POST /api/v1/verification/session`

Authentication:

- `Authorization: Bearer <access_token>`

Request body:

```json
{
  "isIframe": false
}
```

`isIframe` is optional and defaults to `false`.

Behavior:

- If the user already has an active non-terminal Didit session, the backend returns that same session.
- Otherwise, the backend creates a new Didit session using `vendor_data = userId`.
- The backend also marks the user as `pending`.

Raw response shape from the controller/service:

```json
{
  "data": {
    "sessionId": "uuid-from-didit",
    "verificationUrl": "https://verify.didit.me/session/....",
    "status": "Not Started",
    "isExisting": false
  },
  "message": "Verification session created successfully"
}
```

Because Walima uses a global transform interceptor, the actual HTTP response is wrapped like this:

```json
{
  "code": "SUCCESS",
  "message": "Verification session created successfully",
  "response": {
    "data": {
      "sessionId": "uuid-from-didit",
      "verificationUrl": "https://verify.didit.me/session/....",
      "status": "Not Started",
      "isExisting": false
    },
    "message": "Verification session created successfully"
  },
  "traceId": "..."
}
```

Flutter should read:

- `response.data.verificationUrl`
- `response.data.sessionId`
- `response.data.status`
- `response.data.isExisting`

### 5.2 Get current status

`GET /api/v1/verification/status`

Authentication:

- `Authorization: Bearer <access_token>`

Behavior:

- Returns the current user verification status
- Includes the latest Didit session, if one exists
- Syncs the latest session with Didit before returning when possible

Raw response shape:

```json
{
  "data": {
    "identityVerificationStatus": "pending",
    "isVerified": false,
    "latestSession": {
      "sessionId": "uuid-from-didit",
      "status": "In Progress",
      "verificationUrl": "https://verify.didit.me/session/....",
      "createdAt": "2026-06-11T10:00:00.000Z",
      "updatedAt": "2026-06-11T10:05:00.000Z"
    }
  },
  "message": "Verification status retrieved"
}
```

Flutter should use this endpoint as the source of truth for the current screen.

### 5.3 Get all sessions

`GET /api/v1/verification/sessions`

Authentication:

- `Authorization: Bearer <access_token>`

Behavior:

- Returns all sessions for the current user, newest first
- Useful for history/debugging, but not required for the main UX

Raw response shape:

```json
{
  "data": [
    {
      "sessionId": "uuid-from-didit",
      "status": "Approved",
      "verificationUrl": "https://verify.didit.me/session/....",
      "createdAt": "2026-06-11T10:00:00.000Z",
      "updatedAt": "2026-06-11T10:07:00.000Z"
    }
  ],
  "message": "Verification sessions retrieved"
}
```

---

## 6. Didit API used by the backend

The backend is the only component that talks to Didit.

### 6.1 Create Didit session

The backend posts to:

- `POST https://verification.didit.me/v3/session/`

Headers:

- `X-API-Key: <DIDIT_API_KEY>`
- `Content-Type: application/json`

Request body used by Walima:

```json
{
  "workflow_id": "<DIDIT_WORKFLOW_ID>",
  "vendor_data": "<walima-user-id>",
  "callback": "<DIDIT_CALLBACK_URL if isIframe is false>"
}
```

Current backend behavior:

- If `isIframe` is `false` and `DIDIT_CALLBACK_URL` exists, the backend includes `callback`
- If `isIframe` is `true`, the backend omits the callback field

Didit returns at least:

```json
{
  "session_id": "uuid-from-didit",
  "url": "https://verify.didit.me/session/....",
  "status": "Not Started"
}
```

Didit docs also show additional fields such as `session_token`, `session_number`, `workflow_id`, and `workflow_version`.

### 6.2 Retrieve Didit session

Walima’s current code polls Didit by `session_id` from the backend.

The code calls:

- `GET https://verification.didit.me/v3/session/{sessionId}/`

Didit’s public docs also describe a decision retrieval endpoint under the sessions API. If you refactor this area later, confirm the exact endpoint against Didit’s latest OpenAPI spec before changing the backend.

### 6.3 Didit statuses to expect

Didit documents these main statuses:

- `Not Started`
- `In Progress`
- `Approved`
- `Declined`
- `In Review`
- `Awaiting User`
- `Resubmitted`
- `Expired`
- `Abandoned`
- `Kyc Expired`

Walima currently treats these as follows:

- Approved or verified-like values -> approved
- Declined, rejected, failed, expired -> rejected
- In progress, in review, awaiting review, pending-like values -> pending
- Not started is generally shown as pending/under review in the current UI

---

## 7. Webhook flow

This is backend-only, but the Flutter implementation should understand it because it updates the status the app will read.

### Webhook endpoint

- `POST /api/v1/webhook/didit`

### Security

If `DIDIT_WEBHOOK_SECRET` is configured, the backend verifies one of these headers:

- `X-Signature-V2`
- `X-Signature-Simple`
- `X-Signature`

The verification order is:

1. `X-Signature-V2`
2. `X-Signature-Simple`
3. `X-Signature`

The backend rejects invalid signatures with `401`.

### Retry behavior

Didit retries webhook delivery if the endpoint returns `5xx` or `404`.

### Payload fields used by Walima

Walima reads at least:

- `session_id`
- `status`
- `vendor_data`
- `created_at`
- `webhook_type`

The backend stores the full payload in `didit_verification_sessions.webhookPayload` for audit/debugging.

### Backend result of webhook processing

When a webhook says:

- `Approved` -> user becomes `approved` and `isVerified = true`
- `Declined` -> user becomes `rejected` and `isVerified = false`
- `In Progress` -> user becomes `pending`

---

## 8. Flutter screen behavior

### Screen states

Your Flutter verification screen should render these states:

- Not submitted
- Pending / in review
- Approved
- Rejected

### Load flow

When the screen opens:

1. Call `GET /api/v1/verification/status`
2. Render the latest state
3. If there is a latest session with a `verificationUrl`, show a button to continue/reopen it

### Start flow

When the user taps "Start verification":

1. Call `POST /api/v1/verification/session` with `{ "isIframe": false }`
2. Read `response.data.verificationUrl`
3. Open that URL in:
   - an in-app webview, or
   - the system browser
4. After the user finishes or returns, call `GET /api/v1/verification/status` again

### Resume flow

If the backend returns an existing active session:

- Treat `response.data.isExisting = true` as a resume state
- Reopen the existing `verificationUrl`
- Do not create a duplicate session

### Refresh flow

Always provide a manual refresh action that calls:

- `GET /api/v1/verification/status`

This matters because:

- the user may complete verification in another app/browser context
- the webhook may have already updated the backend
- the backend may sync the latest session status on read

---

## 9. Recommended Flutter data models

Use models that mirror the backend, not the Didit internal schema directly.

### Create session response

```dart
class CreateVerificationSessionData {
  final String sessionId;
  final String? verificationUrl;
  final String status;
  final bool isExisting;
}
```

### Status response

```dart
class IdentityVerificationStatusData {
  final String identityVerificationStatus;
  final bool isVerified;
  final LatestSession? latestSession;
}

class LatestSession {
  final String sessionId;
  final String status;
  final String? verificationUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### API envelope

Walima returns a global envelope:

```dart
class ApiEnvelope<T> {
  final String code;
  final String message;
  final T response;
  final String traceId;
}
```

If your HTTP client already unwraps `response.response`, document that clearly in the Flutter code so the next developer does not parse the wrong layer.

---

## 10. Status mapping suggestion for Flutter

Match the current web logic as closely as possible.

### Approved

Treat these as approved:

- `approved`
- `verified`

### Pending

Treat these as pending:

- `under_review`
- `in_review`
- `in_progress`
- `processing`
- `pending`
- `started`
- `submitted`
- `review`
- `manual_review`
- `awaiting_review`
- `not_started`
- `awaiting_user`

### Rejected

Treat these as rejected:

- `declined`
- `rejected`
- `failed`
- `expired`

If a status is unknown, keep the last known backend status and show a neutral fallback UI.

---

## 11. Suggested Flutter package choices

For the current implementation, use:

- `dio` or `http` for backend requests
- `flutter_inappwebview` or `webview_flutter` for the Didit hosted page
- `url_launcher` if you want to open the hosted verification page outside the app

If you use a webview, make sure to:

- allow navigation to the Didit domain
- handle redirects safely
- close or hide the webview after a successful return

---

## 12. Implementation checklist

1. Add a verification service/repository in Flutter for Walima API calls.
2. Read the authenticated user token from the existing auth flow.
3. Build a verification status screen with polling/refresh.
4. Call `GET /verification/status` on page load.
5. Call `POST /verification/session` when starting verification.
6. Open the returned `verificationUrl`.
7. Refresh the status after returning from the hosted flow.
8. Use backend status, not local webview state, as the final truth.
9. Show the verified badge only when backend status is approved.
10. Keep a retry/resume path for active sessions.

---

## 13. Important implementation notes

- The backend already avoids duplicate active sessions.
- The backend already marks user status as pending when a session is created.
- The webhook is the long-term authoritative update path.
- The status endpoint also syncs with Didit when it reads the latest session.
- Flutter should not try to infer final verification on its own.

---

## 14. Official Didit references

These official docs were used to align the integration shape:

- [Didit docs home](https://docs.didit.me/)
- [Create Session](https://docs.didit.me/sessions-api/create-session)
- [Retrieve Session](https://docs.didit.me/sessions-api/retrieve-session)
- [Webhooks](https://docs.didit.me/integration/webhooks)
- [Verification Statuses](https://docs.didit.me/integration/verification-statuses)
- [Flutter SDK overview](https://docs.didit.me/integration/native-sdks/overview)

---

## 15. Short version for an AI coder

If you only keep one paragraph from this document, keep this:

> In Flutter, call Walima backend `POST /api/v1/verification/session` with the user bearer token, open the returned `verificationUrl`, then poll `GET /api/v1/verification/status` until the backend reports `approved`, `pending`, or `rejected`. Do not call Didit directly from Flutter. The backend owns the Didit API key, session creation, session polling, and webhook verification.
