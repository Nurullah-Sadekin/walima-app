# Profile Strength: Flutter Implementation Specification

> Status: implementation-ready  
> Last verified: 2026-07-27  
> Backend source: `Walima-app/walima-engine` at `5eac40f6896ac8031f3ae077d2b9180b58b8a263`  
> Web source: `walima-frontend-new` at `683eb31cdfaaf9c4f53c50ef72ec1e417f170b9d`  
> Flutter code reviewed: `walima` at `aa3ef9a75dbab0f1a0e3acde70ec9310a6188582`

## 1. Decision Summary

Flutter must implement Profile Strength as a backend-driven dashboard feature.

The backend owns:

- which sections and fields count;
- each section's weight;
- field completion checks;
- section and overall scores;
- completion percentages;
- completed status;
- improvement tips.

Flutter owns:

- parsing and displaying the response;
- ordering rows for presentation;
- loading, error, empty, refresh, and success states;
- routing a section row to an existing typed profile form;
- refreshing Profile Strength after any relevant profile mutation;
- localizing known section labels and UI copy.

The `fields` returned by the Profile Strength API are **completion metadata**, not a form schema. Flutter must not generate text fields, lookup fields, or update payloads directly from these keys.

The current Flutter "strength-driven editor" approach should be removed from this feature. A Profile Strength row must open the app's normal typed editor for that profile area.

## 2. Feature Goal

Profile Strength helps a signed-in member understand:

1. their overall profile score;
2. the completion percentage of every profile section;
3. which sections are incomplete;
4. which high-impact sections should be completed first;
5. where to go in the app to add or update the relevant information.

This feature is not:

- an onboarding step counter;
- a client-side score calculator;
- a schema-driven form engine;
- an identity-verification percentage;
- a replacement for the normal profile editing flows.

## 3. Source of Truth

Use these sources in this order:

1. Backend scorer:
   `walima-engine/src/user/services/profile-strength.service.ts`
2. Backend API DTO:
   `walima-engine/src/user/dto/profile-strength.dto.ts`
3. Backend controller:
   `walima-engine/src/user/controllers/user.controller.ts`
4. Web presentation:
   `src/components/frontend/pages/account/profile/dashboard/profile-strength.tsx`
5. Flutter section routing:
   existing typed profile, preference, photo, and contact screens

If a Flutter hardcoded list conflicts with the API response or backend scorer, the backend wins.

## 4. API Contract

### 4.1 Request

```http
GET /api/v1/users/profile/strength
Authorization: Bearer <access-token>
Accept: application/json
```

There is:

- no request body;
- no pagination;
- no query parameter;
- no user ID in the URL, because the backend resolves the authenticated user.

### 4.2 Success envelope

```json
{
  "code": "SUCCESS",
  "message": "Success",
  "response": {
    "overallScore": 66,
    "sections": [],
    "tips": []
  },
  "traceId": "9f3b16ad-3314-43d5-83dd-62fa85c00a0e"
}
```

The useful feature payload is inside `response`.

### 4.3 Payload types

```text
ProfileStrengthData
├── overallScore: integer, 0..100
├── sections: ProfileStrengthSection[]
│   ├── key: string
│   ├── label: string
│   ├── weight: number
│   ├── score: number
│   ├── completionPercentage: integer, 0..100
│   ├── completed: boolean
│   └── fields: ProfileStrengthField[]
│       ├── key: string
│       ├── label: string
│       └── completed: boolean
└── tips: string[]
```

`weight` and `score` must be parsed as `num`/`double`, not only `int`. Section scores can contain one decimal place, such as `2.9` or `4.7`.

### 4.4 Full representative response

This example is illustrative. The API values must be displayed as returned.

```json
{
  "code": "SUCCESS",
  "message": "Success",
  "response": {
    "overallScore": 65,
    "sections": [
      {
        "key": "preferences",
        "label": "Partner Preferences",
        "weight": 20,
        "score": 11.4,
        "completionPercentage": 57,
        "completed": false,
        "fields": [
          { "key": "ageRange", "label": "Age Range", "completed": true },
          { "key": "heightRange", "label": "Height Range", "completed": true },
          {
            "key": "maritalStatusPreference",
            "label": "Marital Status Preference",
            "completed": true
          },
          {
            "key": "educationPreference",
            "label": "Education Preference",
            "completed": true
          },
          {
            "key": "religionPreference",
            "label": "Religion Preference",
            "completed": false
          },
          {
            "key": "locationPreference",
            "label": "Preferred Location",
            "completed": false
          },
          {
            "key": "dietPreference",
            "label": "Diet Preference",
            "completed": false
          }
        ]
      },
      {
        "key": "basic_profile",
        "label": "Basic Profile",
        "weight": 18,
        "score": 12,
        "completionPercentage": 67,
        "completed": false,
        "fields": [
          {
            "key": "dateOfBirth",
            "label": "Date of Birth",
            "completed": true
          },
          {
            "key": "maritalStatus",
            "label": "Marital Status",
            "completed": true
          },
          { "key": "bio", "label": "Bio / About Me", "completed": false }
        ]
      },
      {
        "key": "photos",
        "label": "Profile Photos",
        "weight": 15,
        "score": 15,
        "completionPercentage": 100,
        "completed": true,
        "fields": [
          {
            "key": "hasPhoto",
            "label": "At Least 1 Photo",
            "completed": true
          }
        ]
      }
    ],
    "tips": [
      "Complete your Partner Preferences to improve match quality",
      "Fill in your basic profile details to help others know you better",
      "Adding family details helps build trust with potential matches"
    ]
  },
  "traceId": "9f3b16ad-3314-43d5-83dd-62fa85c00a0e"
}
```

Production responses contain all 12 sections listed in section 5.

### 4.5 Authentication and errors

- `401`: missing, invalid, or expired user access token.
- Other non-2xx responses: use the normal API error parser.
- Preserve the backend `message` for logs.
- Include `traceId` in diagnostic logs when available.
- Do not turn a failed request into a fake 0% profile.

If token refresh is supported by the shared networking layer, allow it to retry the request once. Do not implement a separate token-refresh flow inside Profile Strength.

## 5. Authoritative Scoring Rules

### 5.1 Formula

For each section:

```text
filledCount = number of fields whose backend completion check is true
totalFields = number of configured fields in the section

completionPercentage =
  round((filledCount / totalFields) × 100)

sectionScore =
  round((filledCount / totalFields) × sectionWeight × 10) / 10

section.completed =
  completionPercentage == 100
```

Overall score:

```text
overallScore = round(sum(sectionScore for all sections))
```

The weights total 100.

These formulas are documented for tests and troubleshooting only. Flutter must display the API result and must not independently calculate the production score.

### 5.2 Section and field table

| Order | Section key     | Label               | Weight | API field key             | Backend completion condition                              |
| ----: | --------------- | ------------------- | -----: | ------------------------- | --------------------------------------------------------- |
|     1 | `preferences`   | Partner Preferences |     20 | `ageRange`                | Both `ageMin` and `ageMax` exist                          |
|       |                 |                     |        | `heightRange`             | Both `heightMin` and `heightMax` exist                    |
|       |                 |                     |        | `maritalStatusPreference` | Array contains at least one item                          |
|       |                 |                     |        | `educationPreference`     | Array contains at least one item                          |
|       |                 |                     |        | `religionPreference`      | Array contains at least one item                          |
|       |                 |                     |        | `locationPreference`      | At least one preferred country, state, or city exists     |
|       |                 |                     |        | `dietPreference`          | Array contains at least one item                          |
|     2 | `basic_profile` | Basic Profile       |     18 | `dateOfBirth`             | Date of birth exists                                      |
|       |                 |                     |        | `maritalStatus`           | Marital status exists                                     |
|       |                 |                     |        | `bio`                     | Bio exists and is non-empty/truthy                        |
|     3 | `photos`        | Profile Photos      |     15 | `hasPhoto`                | At least one photo record exists                          |
|     4 | `family`        | Family Details      |      8 | `familyType`              | Family type exists                                        |
|       |                 |                     |        | `familyValues`            | Family values exist                                       |
|     5 | `education`     | Education           |      7 | `hasEducation`            | At least one education record exists                      |
|       |                 |                     |        | `educationLevel`          | At least one education record has an education level      |
|       |                 |                     |        | `fieldOfStudy`            | At least one education record has a field of study        |
|     6 | `profession`    | Profession          |      7 | `hasProfession`           | At least one profession record exists                     |
|     7 | `appearance`    | Appearance          |      5 | `height`                  | Appearance height exists                                  |
|       |                 |                     |        | `bloodGroup`              | Appearance blood group exists                             |
|       |                 |                     |        | `healthInformation`       | Either health condition or special cases exists           |
|     8 | `religion`      | Religion            |      5 | `religion`                | Religion relation/name exists                             |
|       |                 |                     |        | `community`               | Community relation/value exists                           |
|       |                 |                     |        | `religiousBackground`     | Religious background exists                               |
|     9 | `lifestyle`     | Lifestyle           |      5 | `dietType`                | Diet type exists                                          |
|       |                 |                     |        | `drinkingHabits`          | Drinking habits exists                                    |
|       |                 |                     |        | `smokingHabits`           | Smoking habits exists                                     |
|    10 | `location`      | Location            |      5 | `hasLocation`             | At least one location record exists                       |
|       |                 |                     |        | `country`                 | At least one location has a country                       |
|       |                 |                     |        | `city`                    | At least one location has a city                          |
|    11 | `interests`     | Interests & Hobbies |      3 | `hasInterests`            | At least one supported interest category contains an item |
|    12 | `contact`       | Contact Information |      2 | `hasContact`              | At least one contact record exists                        |

Supported interest categories in the backend check are:

- `creativePursuits`
- `outdoorActivities`
- `fitnessAndSports`
- `mediaAndLearning`
- `foodAndCuisine`
- `travelAndLeisure`
- `faithAndCommunity`
- `technologyAndGaming`
- `entertainment`
- `socialAndLifestyle`

### 5.3 Important derived-field semantics

Several response keys are not writable profile properties:

- `hasPhoto` means "a photo record exists."
- `hasEducation` means "an education record exists."
- `hasProfession` means "a profession record exists."
- `hasLocation` means "a location record exists."
- `hasInterests` means "at least one interest category has a value."
- `hasContact` means "a contact record exists."
- `ageRange` represents two fields: `ageMin` and `ageMax`.
- `heightRange` represents two fields: `heightMin` and `heightMax`.
- `locationPreference` represents preferred countries, states, and cities.
- `healthInformation` represents `healthCondition` or `specialCases`.

Flutter must never render these keys as generic text inputs.

### 5.4 Rules that must not be added by the client

The current backend scorer does **not** require:

- a primary photo;
- multiple photos;
- a display name;
- mother tongue;
- languages;
- parent information;
- an "about family" field;
- a marriage timeline;
- a profession title;
- an income range;
- weight;
- body type;
- partner expectations;
- a verified phone number.

These may be valuable profile fields elsewhere, but they do not currently contribute to Profile Strength.

In particular:

- the photo section becomes 100% with any one photo record;
- the profession section becomes 100% with any one profession record;
- the contact section is based on a contact record, not phone verification status;
- family completion only uses `familyType` and `familyValues`.

### 5.5 Percentage and score examples

| Section                  | Filled | Completion | Earned score |
| ------------------------ | -----: | ---------: | -----------: |
| Preferences, weight 20   |    1/7 |        14% |          2.9 |
| Preferences, weight 20   |    4/7 |        57% |         11.4 |
| Basic Profile, weight 18 |    1/3 |        33% |          6.0 |
| Basic Profile, weight 18 |    2/3 |        67% |         12.0 |
| Family, weight 8         |    1/2 |        50% |          4.0 |
| Education, weight 7      |    2/3 |        67% |          4.7 |
| Appearance, weight 5     |    1/3 |        33% |          1.7 |

The overall score is not the average of section percentages. It is the rounded sum of weighted section scores.

### 5.6 Tips

The backend adds one tip for every incomplete section, then returns the first three in configured section order.

The current order is descending by business importance:

1. Partner Preferences
2. Basic Profile
3. Profile Photos
4. Family Details
5. Education
6. Profession
7. Appearance
8. Religion
9. Lifestyle
10. Location
11. Interests & Hobbies
12. Contact Information

Flutter must display the returned tips. It must not create a separate tip-ranking algorithm.

## 6. Flutter UI Specification

### 6.1 Placement

Display the Profile Strength card on the authenticated home/dashboard screen near the profile summary, matching the web dashboard feature.

Do not show it to signed-out users.

### 6.2 Visibility rule

- Hide the entire card when `overallScore == 100`.
- Show the card for every score from 0 through 99.
- Do not hide a valid response merely because all rows were filtered accidentally.
- Do not show a fake 0% card before the request has completed.

### 6.3 Loaded card structure

The card contains:

1. Header:
   - localized "Profile Strength" title;
   - circular overall score indicator;
   - numeric score from 0 to 100.
2. Incomplete rows.
3. A localized "Completed" divider, only when both incomplete and completed rows exist.
4. Completed rows.
5. A "Tips to improve" panel when `tips` is not empty.

### 6.4 Section ordering

Create two lists:

```dart
final incomplete = sections.where((section) => !section.completed).toList()
  ..sort((a, b) => b.weight.compareTo(a.weight));

final completed =
    sections.where((section) => section.completed).toList(growable: false);
```

Rules:

- incomplete sections appear first;
- incomplete sections are sorted by `weight` descending;
- equal weights keep API order;
- completed sections appear after the divider;
- completed sections keep API order.

Do not show only the first two incomplete sections. Do not require "See More" to discover the remaining sections. If vertical space is constrained, make the card content naturally scroll with the page.

### 6.5 Section row

Every row shows:

- section label;
- `completionPercentage%`;
- a linear progress bar;
- completed icon when `completed == true`;
- forward chevron when `completed == false`;
- a full-row tap target.

Do not replace the percentage with "`n` fields left." Field count can be added as secondary accessibility/help text later, but web parity requires the section percentage.

### 6.6 Color thresholds

Use the same threshold for the overall ring, percentage text, and section progress bar:

|  Score | Semantic color | Web reference                    |
| -----: | -------------- | -------------------------------- |
| 80–100 | success/green  | `#10b981` ring/bar, emerald text |
|  50–79 | warning/amber  | `#f59e0b` ring, amber bar/text   |
|   0–49 | danger/rose    | `#f43f5e` ring, rose bar/text    |

Prefer app theme semantic colors when they preserve these meanings and sufficient contrast.

Clamp visual progress to 0–100 defensively:

```dart
final visualPercent = completionPercentage.clamp(0, 100);
final progress = visualPercent / 100.0;
```

Continue to log malformed out-of-range API values rather than silently treating them as valid domain data.

### 6.7 Tips panel

When `tips.isNotEmpty`:

- show the localized heading "Tips to improve";
- show each returned tip as a bullet;
- preserve API order;
- do not show an empty panel;
- do not limit the list again on the client.

The backend currently returns at most three tips.

### 6.8 Loading state

Use a card skeleton, not a page-level blocking spinner:

- title skeleton;
- circular score skeleton;
- approximately five row skeletons;
- preserve surrounding dashboard layout.

The rest of the home screen must remain usable while this request is loading.

### 6.9 Error state

If no previously loaded data exists:

- show a compact inline error inside the card;
- provide a localized Retry action;
- do not show 0%;
- do not remove the feature silently.

If stale data exists and refresh fails:

- keep showing stale data;
- show a non-blocking refresh failure indicator or snackbar;
- retain Retry/pull-to-refresh behavior.

### 6.10 Empty or malformed success state

A successful backend response normally contains all 12 sections.

If `response` exists but `sections` is empty:

- log the `traceId`;
- show the inline unavailable/retry state;
- do not interpret it as a complete profile;
- do not render an empty 0% card.

### 6.11 Accessibility

- The overall indicator must have a semantic label such as
  "Profile strength 72 percent."
- Each row should announce:
  "`<section label>`, `<percentage>` percent, completed/incomplete."
- A row must be keyboard/switch-accessible as one tap target.
- Do not communicate state by color alone; keep percentage and icon.
- Support text scaling without truncating the percentage or hiding the action.
- Mirror directional icons and layout for RTL Arabic.

### 6.12 Localization

Known backend section keys should map to local ARB strings:

```text
preferences
basic_profile
photos
family
education
profession
appearance
religion
lifestyle
location
interests
contact
```

Use the API `label` as a fallback for unknown future keys.

The backend currently returns English labels and English tip sentences. For full Bengali and Arabic support:

- localize known section labels by `section.key`;
- localize known tip copy by the related section key if the backend later returns keyed tips;
- until the API returns tip keys, keep a local mapping from the 12 exact backend tip strings, with API text as fallback;
- localize all static card copy through ARB;
- never derive localization lookup keys from a humanized field label.

## 7. Navigation Contract

### 7.1 Core rule

A row opens an existing typed profile-management flow. It does not open a form generated from `fields`.

The API field list may help choose which existing subsection to open first. It must not control the inputs rendered inside that subsection.

### 7.2 Section destination matrix

| Section key     | Destination                                 | Incomplete-field routing detail                                                                                                                                                                  |
| --------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `preferences`   | Existing Partner Preferences flow           | Route `locationPreference` to preference location; `educationPreference` to preference education/career; `dietPreference` to other preferences; remaining preference fields to basic preferences |
| `basic_profile` | Existing About Myself or Basic Details flow | Route `bio` to About Myself; route `dateOfBirth` or `maritalStatus` to Basic Details                                                                                                             |
| `photos`        | Existing photo gallery/upload flow          | `hasPhoto` means the user must add a photo record                                                                                                                                                |
| `family`        | Existing Family Details editor              | Open the full typed form                                                                                                                                                                         |
| `education`     | Existing Education & Career editor          | `hasEducation` means add an education record; never show a boolean/text field named "hasEducation"                                                                                               |
| `profession`    | Existing Education & Career editor          | `hasProfession` means add a profession record                                                                                                                                                    |
| `appearance`    | Existing Basic/Appearance editor            | Must expose height, blood group, and the app's typed health-information controls                                                                                                                 |
| `religion`      | Existing Religious Background editor        | Open the full typed form                                                                                                                                                                         |
| `lifestyle`     | Existing Basic/Lifestyle editor             | Must expose diet, drinking, and smoking controls                                                                                                                                                 |
| `location`      | Existing Location editor                    | `hasLocation` means add a location record                                                                                                                                                        |
| `interests`     | Existing Hobbies and Interests editor       | `hasInterests` means select at least one supported interest                                                                                                                                      |
| `contact`       | Existing Contact Settings/editor            | Must add a backend contact record; phone verification alone does not satisfy this scorer unless it creates that record                                                                           |

### 7.3 Selecting a subsection

For sections that span multiple Flutter screens:

1. find the first `fields` item where `completed == false`;
2. map that known key to the appropriate existing subsection;
3. open the full subsection form;
4. if no field is incomplete, open the section's normal view or management screen;
5. if the field key is unknown, open the section's normal root editor and log the unknown key.

Do not maintain a client copy of "required fields" as a fallback. The API always returns the current field list. If the list is missing, use the section root destination.

### 7.4 Unknown section key

For an unknown future `section.key`:

- render the API label and percentage;
- keep the row visible;
- route to the generic Edit Profile screen if available;
- otherwise disable the row action with an accessible explanation;
- log/track the unknown key;
- never silently route it to About Myself.

### 7.5 Completed rows

Completed rows remain visible when the overall score is below 100.

On tap:

- open the normal section view if Flutter has a section view;
- otherwise open the same typed management/editor screen;
- never open a reduced "incomplete fields only" editor.

## 8. State, Cache, and Refresh Behavior

### 8.1 Backend behavior

`GET /users/profile/strength` calculates the detailed response from the current profile and relations on every request.

The backend also stores an hourly `profileStrengthScore` cache on the user for reminder/other backend jobs. That cached scalar is separate from this endpoint and must not be used to render the detailed Profile Strength card.

### 8.2 Flutter state model

Recommended state:

```dart
sealed class ProfileStrengthState {
  const ProfileStrengthState();
}

final class ProfileStrengthInitial extends ProfileStrengthState {}

final class ProfileStrengthLoading extends ProfileStrengthState {
  const ProfileStrengthLoading({this.previous});
  final ProfileStrengthData? previous;
}

final class ProfileStrengthLoaded extends ProfileStrengthState {
  const ProfileStrengthLoaded(this.data);
  final ProfileStrengthData data;
}

final class ProfileStrengthFailure extends ProfileStrengthState {
  const ProfileStrengthFailure({
    required this.message,
    this.traceId,
    this.previous,
  });

  final String message;
  final String? traceId;
  final ProfileStrengthData? previous;
}
```

The same behavior may be implemented with `AsyncValue<ProfileStrengthData>` or the app's existing notifier pattern. The required part is preserving previous data during refresh.

### 8.3 Load events

Load Profile Strength:

- when the authenticated home/dashboard is first opened;
- on user-initiated retry;
- on pull-to-refresh;
- after returning from a Profile Strength destination if a mutation succeeded;
- after any profile mutation performed from elsewhere in the app;
- after photo add/delete;
- after contact add/delete;
- after education, profession, or location record add/delete;
- when the authenticated user changes.

### 8.4 Mutation refresh sequence

```text
Open typed editor
    ↓
User saves through the normal typed repository
    ↓
Mutation returns success
    ↓
Pop with result = changed
    ↓
Invalidate profile + profile strength
    ↓
GET /users/profile/strength
    ↓
Replace card with new backend result
```

Do not refresh merely because a route was opened and closed. Refresh when:

- the editor returns a successful change result; or
- the app cannot reliably know whether the destination changed data.

### 8.5 Cache policy

An in-memory per-authenticated-user cache is acceptable.

Requirements:

- scope cached data to the authenticated user;
- clear it on logout/account switch;
- mark it stale after relevant mutations;
- never share it across users;
- do not persist it as the score source;
- do not let a long time-to-live prevent immediate post-save refresh.

The web currently uses an hour revalidation setting for passive dashboard reads. Flutter may use a short stale time for repeat home builds, but successful profile changes must invalidate it immediately.

### 8.6 Concurrency

- Deduplicate simultaneous load requests.
- Ignore a late response belonging to a previous signed-in user.
- Do not allow an older request to overwrite a newer forced refresh.
- Disable repeated Retry taps while a request is active.

## 9. Recommended Flutter Data Layer

### 9.1 Non-null domain models

Keep wire parsing defensive, but make successfully parsed domain data non-null:

```dart
final class ProfileStrengthData {
  const ProfileStrengthData({
    required this.overallScore,
    required this.sections,
    required this.tips,
  });

  final int overallScore;
  final List<ProfileStrengthSection> sections;
  final List<String> tips;

  factory ProfileStrengthData.fromJson(Map<String, dynamic> json) {
    return ProfileStrengthData(
      overallScore: (json['overallScore'] as num).round(),
      sections: (json['sections'] as List<dynamic>)
          .map(
            (item) => ProfileStrengthSection.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
      tips: (json['tips'] as List<dynamic>)
          .map((item) => item as String)
          .toList(growable: false),
    );
  }
}

final class ProfileStrengthSection {
  const ProfileStrengthSection({
    required this.key,
    required this.label,
    required this.weight,
    required this.score,
    required this.completionPercentage,
    required this.completed,
    required this.fields,
  });

  final String key;
  final String label;
  final double weight;
  final double score;
  final int completionPercentage;
  final bool completed;
  final List<ProfileStrengthField> fields;

  factory ProfileStrengthSection.fromJson(Map<String, dynamic> json) {
    return ProfileStrengthSection(
      key: json['key'] as String,
      label: json['label'] as String,
      weight: (json['weight'] as num).toDouble(),
      score: (json['score'] as num).toDouble(),
      completionPercentage:
          (json['completionPercentage'] as num).round(),
      completed: json['completed'] as bool,
      fields: (json['fields'] as List<dynamic>)
          .map(
            (item) => ProfileStrengthField.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  ProfileStrengthField? get firstIncompleteField {
    for (final field in fields) {
      if (!field.completed) return field;
    }
    return null;
  }
}

final class ProfileStrengthField {
  const ProfileStrengthField({
    required this.key,
    required this.label,
    required this.completed,
  });

  final String key;
  final String label;
  final bool completed;

  factory ProfileStrengthField.fromJson(Map<String, dynamic> json) {
    return ProfileStrengthField(
      key: json['key'] as String,
      label: json['label'] as String,
      completed: json['completed'] as bool,
    );
  }
}
```

If the project uses generated JSON serialization, model the same types with its normal generator rather than hand-maintaining duplicate serializers.

### 9.2 Envelope parsing

```dart
final json = response.data as Map<String, dynamic>;

if (json['code'] != 'SUCCESS') {
  throw ApiException(
    message: json['message']?.toString() ?? 'Unable to load profile strength',
    traceId: json['traceId']?.toString(),
  );
}

final payload = json['response'];
if (payload is! Map<String, dynamic>) {
  throw ApiException(
    message: 'Profile strength response is missing',
    traceId: json['traceId']?.toString(),
  );
}

return ProfileStrengthData.fromJson(payload);
```

### 9.3 Repository

```dart
abstract interface class ProfileStrengthRepository {
  Future<ProfileStrengthData> getProfileStrength();
}

final class ApiProfileStrengthRepository
    implements ProfileStrengthRepository {
  ApiProfileStrengthRepository(this._client);

  final DioClient _client;

  @override
  Future<ProfileStrengthData> getProfileStrength() async {
    final response = await _client.get(
      AppUrls.getProfileStrength,
      isTokenRequired: true,
    );

    return parseProfileStrengthEnvelope(response.data);
  }
}
```

Do not return a synthetic `ProfileStrengthData(overallScore: 0, ...)` from a catch block. Return/throw a typed failure so the UI can distinguish error from a genuinely empty profile.

### 9.4 Presentation transformation

Keep display grouping outside the API model:

```dart
final class ProfileStrengthViewData {
  ProfileStrengthViewData.fromDomain(ProfileStrengthData data)
      : overallScore = data.overallScore,
        incomplete = _stableWeightSort(
          data.sections.where((section) => !section.completed).toList(),
        ),
        completed = data.sections
            .where((section) => section.completed)
            .toList(growable: false),
        tips = data.tips;

  final int overallScore;
  final List<ProfileStrengthSection> incomplete;
  final List<ProfileStrengthSection> completed;
  final List<String> tips;
}
```

Do not mutate the API model list in place.

## 10. Update Endpoints Used by Typed Editors

Profile Strength itself is read-only. Edits continue through the existing profile APIs:

| Area          | Read                             | Update                                                    |
| ------------- | -------------------------------- | --------------------------------------------------------- |
| Basic profile | `GET /users/profile/basic`       | `PUT /users/profile/basic`                                |
| Preferences   | `GET /users/profile/preferences` | `PUT /users/profile/preferences`                          |
| Photos        | `GET /users/profile/photos`      | `PUT /users/profile/photos` plus existing upload workflow |
| Family        | `GET /users/profile/family`      | `PUT /users/profile/family`                               |
| Education     | `GET /users/profile/education`   | `PUT /users/profile/educations`                           |
| Profession    | `GET /users/profile/profession`  | `PUT /users/profile/professions`                          |
| Appearance    | `GET /users/profile/appearance`  | `PUT /users/profile/appearance`                           |
| Religion      | `GET /users/profile/religion`    | `PUT /users/profile/religion`                             |
| Lifestyle     | `GET /users/profile/lifestyle`   | `PUT /users/profile/lifestyle`                            |
| Location      | `GET /users/profile/locations`   | `PUT /users/profile/locations`                            |
| Interests     | `GET /users/profile/interests`   | `PUT /users/profile/interests`                            |
| Contacts      | `GET /users/profile/contacts`    | `PUT /users/profile/contacts`                             |

Use the existing typed request models and repository methods for these endpoints.

Do not send:

```json
{
  "hasEducation": "yes",
  "hasPhoto": true,
  "healthInformation": "..."
}
```

Those are scorer concepts, not valid universal update fields.

## 11. What Is Wrong in the Current Flutter Implementation

The reviewed implementation has useful API model and refresh foundations, but its UI/editing contract diverges from the backend and web feature.

| Current behavior                                                   | Why it is wrong                                                        | Required replacement                                                         |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Maintains `_requiredFieldsBySection` in Flutter                    | The list is stale and disagrees with the backend                       | Remove it; consume API `fields` only as status metadata                      |
| Treats API fields as dynamic form definitions                      | Derived and compound keys are not writable fields                      | Open the existing typed section form                                         |
| Builds fallback text/lookup inputs for unknown strength keys       | API labels/keys do not define update type, validation, or storage path | Log unknown keys and open the section root editor                            |
| Sends "unknown strength fields" through a universal update payload | Can create invalid or destructive nested/record payloads               | Remove this Profile Strength-specific save path                              |
| Passes `strengthFields` through router extras                      | Couples navigation to a reduced dynamic editor                         | Pass only typed destination/optional section key                             |
| Shows only incomplete sections                                     | Web shows incomplete and completed sections until overall 100          | Render both groups with a Completed divider                                  |
| Shows only two rows until "See More"                               | Hides actionable profile information                                   | Render all rows in the card/page flow                                        |
| Shows "`n` fields left" instead of section percent                 | Does not match the feature's score presentation                        | Show `completionPercentage%` and a progress bar                              |
| Does not render backend tips                                       | Loses the backend's prioritized guidance                               | Render the returned `tips` panel                                             |
| Hides the widget on error                                          | Gives no recovery path and can look like 100%                          | Show inline error + Retry                                                    |
| Defaults unknown section to About Myself                           | Sends users to an unrelated form                                       | Use generic Edit Profile fallback and log                                    |
| Uses phone verification as the contact action                      | Backend checks for a contact record, not verification status           | Route to contact management unless verification creates the required contact |
| Relies on cached `_hasLoadedProfileStrength` on home revisit       | Score may remain stale after edits made elsewhere                      | Invalidate after every relevant mutation and refresh on changed result       |

### 11.1 Specific stale hardcoded rules

The current Flutter fallback list includes fields the scorer does not use:

- Basic Profile:
  `motherTongue`, `languages`, `displayName`
- Photos:
  `hasPrimaryPhoto`, `hasMultiplePhotos`
- Family:
  `parentInfo`, `aboutFamily`, `marriageTimeline`
- Profession:
  `profession`, `incomeRange`
- Appearance:
  `weight`, `bodyType`
- Preferences:
  `partnerExpectations`

It also misses current Appearance rules:

- `bloodGroup`
- `healthInformation`

This is why the client must not duplicate the scorer.

## 12. Implementation Plan for the Flutter Repository

### Phase 1: Data contract

1. Keep or replace `profile_strength_response.dart` with strict typed models.
2. Parse `weight` and `score` as `double`.
3. Preserve `traceId` at envelope/error level.
4. Make repository failures distinct from a valid 0 score.
5. Add fixture-driven parser tests.

### Phase 2: State and invalidation

1. Move Profile Strength into a focused repository/provider if practical.
2. Preserve previous data during refresh.
3. add explicit `invalidateAndRefresh()` behavior.
4. call it after all relevant successful profile mutations.
5. clear state on logout/user change.
6. protect against overlapping/stale requests.

### Phase 3: Dashboard UI

1. Replace `CompleteProfileSection` content with the Profile Strength card.
2. add overall circular indicator.
3. render all incomplete rows sorted by weight.
4. render Completed divider and completed rows.
5. render returned tips.
6. add card skeleton, inline error, and Retry.
7. hide only for a valid 100 score.

### Phase 4: Navigation

1. Remove strength-driven field rendering.
2. remove dynamic unknown-field saving from this flow.
3. map the 12 section keys to typed destinations.
4. use the first incomplete field only to choose an existing subsection.
5. return `changed == true` from successful editors.
6. refresh after changed results.

### Phase 5: Localization and accessibility

1. add ARB entries for card copy and all known section labels.
2. add localized backend tip mapping until the API provides tip keys.
3. add semantic labels for score and rows.
4. verify Bengali text scaling.
5. verify Arabic RTL layout and chevrons.

## 13. Test Plan

### 13.1 Model/parser tests

Test:

- successful envelope;
- decimal `score`;
- integer `score`;
- all 12 known section keys;
- empty tips;
- malformed/missing `response`;
- non-success code;
- malformed section data;
- `traceId` preservation.

### 13.2 Presentation transformation tests

Given API order containing mixed completion states:

- incomplete rows come first;
- incomplete rows sort by weight descending;
- equal-weight rows keep API order;
- completed rows keep API order;
- tips keep API order;
- no production score is recalculated.

### 13.3 Widget tests

Verify:

- loading skeleton;
- 0–49 danger colors;
- 50–79 warning colors;
- 80–99 success colors;
- card hidden at exactly 100;
- all sections rendered for a below-100 response;
- divider shown only when both groups exist;
- completed icon versus chevron;
- progress uses `completionPercentage`;
- tips panel hidden for empty tips;
- tips panel renders all returned tips;
- initial error with Retry;
- refresh failure keeps stale data.

### 13.4 Navigation tests

Cover every known section key.

Special cases:

- `basic_profile.bio` opens About Myself;
- `basic_profile.dateOfBirth` opens Basic Details;
- `preferences.locationPreference` opens preference location;
- `education.hasEducation` opens education record management;
- `profession.hasProfession` opens profession record management;
- `photos.hasPhoto` opens photo upload/management;
- `contact.hasContact` opens contact management;
- unknown field opens the known section root;
- unknown section opens generic Edit Profile, not About Myself.

### 13.5 Refresh tests

- first home open loads once;
- concurrent callers deduplicate;
- successful edit triggers forced refresh;
- cancelled/no-change edit follows the chosen refresh policy;
- photo deletion refreshes;
- record deletion refreshes;
- pull-to-refresh refreshes;
- logout clears the previous user's score;
- late previous-user response is discarded.

### 13.6 Backend contract fixtures

Keep at least these fixtures:

1. empty profile: score 0, 12 incomplete sections, first three tips;
2. partially completed profile with decimal section scores;
3. all sections completed: score 100;
4. profession record with no title: Profession is complete under current rules;
5. family with only family type and values: Family is complete;
6. one photo without primary/multiple status: Photos is complete;
7. contact record without assuming phone verification: Contact is complete.

Fixtures 4–7 prevent the Flutter app from reintroducing client-only completion rules.

## 14. Acceptance Criteria

The feature is complete when all of the following are true:

- [ ] Flutter calls authenticated `GET /users/profile/strength`.
- [ ] The app reads the payload from the standard `response` envelope.
- [ ] `weight` and `score` support decimals.
- [ ] The app never calculates or overrides the production score.
- [ ] The card is hidden only for a valid 100 score.
- [ ] All below-100 API sections are displayed.
- [ ] Incomplete sections are sorted by weight descending.
- [ ] Completed sections appear below a Completed divider.
- [ ] Every row shows API completion percentage and progress.
- [ ] Overall and section colors use the 50 and 80 thresholds.
- [ ] Backend tips are displayed in order.
- [ ] Loading uses a card skeleton.
- [ ] Initial errors show Retry instead of disappearing.
- [ ] Stale data remains visible during refresh failure.
- [ ] Every known section routes to the correct existing typed flow.
- [ ] API `fields` are never treated as a dynamic form schema.
- [ ] Derived keys such as `hasEducation` never become input fields.
- [ ] No Profile Strength-specific universal unknown-field payload is sent.
- [ ] Successful relevant mutations invalidate and refresh the score.
- [ ] State is scoped to the authenticated user and cleared on logout.
- [ ] Static copy, known labels, and known tips are localized.
- [ ] Score and row states have accessible semantic labels.
- [ ] Parser, ordering, widget, routing, and refresh tests pass.

## 15. Backend Change Protocol

Future backend changes may add:

- a new section;
- a new field status;
- different weights;
- different tip text;
- a different completion predicate.

Flutter behavior must remain forward-compatible:

- display unknown sections using API label and percentage;
- route unknown sections to generic Edit Profile;
- do not crash on a new key;
- log unknown keys for follow-up;
- do not add new dynamic inputs;
- update localization and typed navigation mappings in a normal app release.

If product needs the app to dynamically build completion forms in the future, the backend must expose a separate, versioned form-schema contract containing field type, data path, options source, validation, dependency rules, record operations, and update endpoint. The current Profile Strength response does not contain that information.
