# Flutter Integration Doc: Bio Template + Connect Message Template

This doc maps the current web behavior (`walima-frontend-new`) with backend APIs (`walima-engine`) so Flutter can implement the same flow.

## 1) API Base + Response Envelope

- Backend prefix: `/api/v1`
- Most success responses are wrapped as:

```json
{
  "code": "SUCCESS",
  "message": "Success or custom message",
  "response": { }
}
```

For these template APIs, the useful payload is inside `response`.

## 2) Feature Scope (What Flutter Should Implement)

1. Bio Template list (for onboarding bio field)
2. Bio Template auto-suggest (based on onboarding answers)
3. Connect Message Template list (for connect modal)
4. Send connection request with optional `connectMessageTemplateId`

## 3) Data Models (Flutter)

## 3.1 BioTemplate

```dart
class BioTemplate {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final int priority;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

## 3.2 ConnectMessageTemplate

```dart
class ConnectMessageTemplate {
  final String id;
  final String title;
  final String content;
  final int priority;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

## 4) Public Template APIs

## 4.1 GET `/public/bio-templates`

Purpose:
- Load all active bio templates for "Show Templates".

Response shape:

```json
{
  "code": "SUCCESS",
  "message": "Success",
  "response": {
    "templates": [
      {
        "id": "uuid",
        "title": "Faith-centered bio template",
        "content": "I am a practicing Muslim...",
        "tags": ["religious", "faith", "general"],
        "priority": 10,
        "isActive": true
      }
    ]
  }
}
```

Notes:
- Backend already filters `isActive=true`.
- Backend sort: `priority DESC`, then `createdAt DESC`.

## 4.2 POST `/public/bio-templates/suggest`

Purpose:
- Get one suggested template for onboarding.

Request body (web parity):

```json
{
  "maritalStatus": "Never Married",
  "workingAs": "Software Engineer",
  "workWith": "Private Company",
  "religion": "Islam",
  "age": 28
}
```

Response shape:

```json
{
  "code": "SUCCESS",
  "message": "Success",
  "response": {
    "template": {
      "id": "uuid",
      "title": "...",
      "content": "...",
      "tags": ["engineer", "faith", "general"]
    },
    "matchedTags": ["general", "engineer", "religious", "faith"]
  }
}
```

Edge case:
- If no active templates:

```json
{
  "response": {
    "template": null,
    "matchedTags": []
  }
}
```

## 4.3 GET `/public/connect-message-templates`

Purpose:
- Load connect message templates for connect modal.

Response shape:

```json
{
  "code": "SUCCESS",
  "message": "Success",
  "response": {
    "templates": [
      {
        "id": "uuid",
        "title": "Formal",
        "content": "Assalamu Alaikum, I came across your profile...",
        "priority": 10,
        "isDefault": true,
        "isActive": true
      }
    ]
  }
}
```

Notes:
- Backend sort: `isDefault DESC`, `priority DESC`, `createdAt DESC`.
- Web fallback behavior: if API fails/empty, it can use local hardcoded defaults.

## 5) Connection API Mapping

## 5.1 POST `/connections`

Purpose:
- Send connection request with selected message template.

Request body (Flutter should send):

```json
{
  "receiverId": "target-user-uuid",
  "requestType": "connection",
  "message": "User-edited or template content",
  "markAsDefaultConnectionMessage": false,
  "connectMessageTemplateId": "selected-template-uuid",
  "isPriority": false
}
```

Notes:
- `connectMessageTemplateId` is optional.
- If user edits the text manually, still send selected template ID if chosen (web does this).
- Backend validates:
  - `receiverId` UUID required
  - `message` max 500
  - `connectMessageTemplateId` must be UUID if provided

Response:
- Wrapped success with connection data and message.

## 6) UI/Flow Mapping (From Web to Flutter)

## 6.1 Onboarding Bio field flow

1. On bio section, show two actions:
- `Auto Suggest`
- `Show Templates`

2. `Auto Suggest`:
- Build payload from current onboarding fields:
  - `maritalStatus`
  - `workingAs`
  - `workWith`
  - `religion`
  - `age` (derived from DOB)
- Call `POST /public/bio-templates/suggest`
- If `template.content` exists, set bio text with it.

3. `Show Templates`:
- Lazy-load `GET /public/bio-templates`
- Display tag chips + list (optional parity feature)
- On pick, set `bio` field to `template.content`.

## 6.2 Connect modal flow

1. Open modal on connect action.
2. Lazy-load `GET /public/connect-message-templates` once.
3. Preselect template:
- First `isDefault == true`
- Else highest `priority`
4. Set textarea message from selected template content.
5. On template click, replace textarea with template content.
6. On submit call `POST /connections` with:
- `receiverId`
- `requestType: "connection"`
- `message`
- `markAsDefaultConnectionMessage`
- `connectMessageTemplateId` (if selected)

## 7) Flutter Networking Parsing Example

```dart
final envelope = jsonDecode(response.body) as Map<String, dynamic>;
final payload = envelope['response'] as Map<String, dynamic>;
final templates = (payload['templates'] as List)
    .map((e) => ConnectMessageTemplate.fromJson(e as Map<String, dynamic>))
    .toList();
```

## 8) Error Handling Requirements

- On API non-200, backend returns structured error with `code` like:
  - `E_BAD_REQUEST`
  - `E_UNAUTHORIZED`
  - `E_FORBIDDEN`
  - `E_NOT_FOUND`
- For Flutter UX parity:
  - Show toast/snackbar on failure.
  - Keep modal/form state intact so user can retry.

## 9) Admin APIs (Optional, if Flutter admin panel exists)

Protected by admin token:

- Bio templates:
  - `GET /admin/bio-templates`
  - `GET /admin/bio-templates/:id`
  - `POST /admin/bio-templates`
  - `PUT /admin/bio-templates/:id`
  - `DELETE /admin/bio-templates/:id`

- Connect message templates:
  - `GET /admin/connect-message-templates`
  - `GET /admin/connect-message-templates/:id`
  - `POST /admin/connect-message-templates`
  - `PUT /admin/connect-message-templates/:id`
  - `DELETE /admin/connect-message-templates/:id`

Admin list query format (same for both):
- `page`, `perPage`, `sort`, `order`, `q`, `ids`, `filter`

Example:
- `filter={"isActive":true}`
- connect template also supports `filter={"isDefault":true}`

## 10) Important Parity Rules

1. Always read payload from `response` (not top-level directly).
2. Treat `connectMessageTemplateId` as optional but pass when selected.
3. Keep message length <= 500.
4. Use backend-selected active templates only; do not assume hardcoded IDs.
5. For connect templates, select default template first if present.

---

If needed, add a second doc with ready-to-copy Flutter `dio` service + model classes.
