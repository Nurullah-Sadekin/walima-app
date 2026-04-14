# Lookups API Guide

The Lookups API provides backend-managed option lists used across the Walima platform � in web forms, mobile apps, search filters, and anywhere selectable options are needed.

---

## Base Endpoint

```http
GET /lookups?categorySlug={slug}
```

## Authentication

Authenticated requests include a bearer token header. Some lookup categories may be accessible without authentication; consult with the backend team for per-category access rules.

```http
Authorization: Bearer <token>
```

---

## Query Parameters

| Parameter      | Type   | Required | Description                                    |
| -------------- | ------ | -------- | ---------------------------------------------- |
| `categorySlug` | string | Yes      | Identifier for the lookup category to retrieve |
| `search`       | string | No       | Optional text filter to narrow results         |

### Example with search

```http
GET /lookups?categorySlug=professions&search=eng
```

---

## Response Shape

```json
{
  "data": [
    {
      "key": "software-engineer",
      "label": "Software Engineer"
    },
    {
      "key": "doctor",
      "label": "Doctor"
    }
  ]
}
```

### Response fields

| Field          | Type   | Description                                                |
| -------------- | ------ | ---------------------------------------------------------- |
| `data`         | array  | List of lookup items for the requested category            |
| `data[].key`   | string | Stable identifier � use this as the stored/submitted value |
| `data[].label` | string | Human-readable display text                                |

> **Important:** Always store `key` as the submitted value and display `label` to the user. Keys remain stable even when labels are updated.

---

## Available Category Slugs

### Religion & Community

| Slug (dynamic)      | Description                                    |
| ------------------- | ---------------------------------------------- |
| `islam`             | Communities within Islam (Sunni, Shia, etc.)   |
| `christianity`      | Communities within Christianity                |
| `hinduism`          | Communities within Hinduism                    |
| _(other religions)_ | The slug matches the lowercased religion value |

The community slug is always the selected religion value. If a user selects **Islam**, request:

```http
GET /lookups?categorySlug=islam
```

### Profession & Career

| Slug           | Description                |
| -------------- | -------------------------- |
| `professions`  | List of profession options |
| `income-range` | Annual income brackets     |

### Education

| Slug               | Description                    |
| ------------------ | ------------------------------ |
| `education-levels` | Formal education level options |

### Hobbies & Interests

| Slug                 | Description                    |
| -------------------- | ------------------------------ |
| `creative-pursuits`  | Creative hobby categories      |
| `outdoor-activities` | Outdoor activity categories    |
| `fitness-and-sports` | Fitness and sports categories  |
| `media-and-learning` | Media and self-learning topics |
| `food-and-cuisine`   | Food and culinary interests    |
| `travel-and-leisure` | Travel styles and leisure      |

---

## Use Cases

### 1. Community selection by religion

When a user selects their religion, load the relevant communities for that religion.

Request:

```http
GET /lookups?categorySlug=islam
```

Response:

```json
{
  "data": [
    { "key": "sunni", "label": "Sunni" },
    { "key": "shia", "label": "Shia" },
    { "key": "hanafi", "label": "Hanafi" }
  ]
}
```

Store `key`, display `label`. Disable the community field until a religion is selected.

---

### 2. Profession selection

Used in profile setup, onboarding, preferences, search filters, and biodata generation.

Request:

```http
GET /lookups?categorySlug=professions
```

Response:

```json
{
  "data": [
    { "key": "software-engineer", "label": "Software Engineer" },
    { "key": "doctor", "label": "Doctor" },
    { "key": "teacher", "label": "Teacher" }
  ]
}
```

---

### 3. Income range selection

Used in work/career sections and preference forms.

Request:

```http
GET /lookups?categorySlug=income-range
```

Response:

```json
{
  "data": [
    { "key": "below-25k", "label": "Below $25,000" },
    { "key": "25k-50k", "label": "$25,000 � $50,000" },
    { "key": "50k-100k", "label": "$50,000 � $100,000" },
    { "key": "above-100k", "label": "Above $100,000" }
  ]
}
```

---

### 4. Education level selection

Used in profile and partner preference forms.

Request:

```http
GET /lookups?categorySlug=education-levels
```

---

### 5. Hobbies and interests

Six separate categories, each fetched independently.

```http
GET /lookups?categorySlug=creative-pursuits
GET /lookups?categorySlug=outdoor-activities
GET /lookups?categorySlug=fitness-and-sports
GET /lookups?categorySlug=media-and-learning
GET /lookups?categorySlug=food-and-cuisine
GET /lookups?categorySlug=travel-and-leisure
```

> **Note:** Hobbies are stored as labels rather than keys in the current user data model. Confirm the expected payload format with the backend before submitting selected hobbies.

---

### 6. Server-side search filtering

For categories with large lists (e.g. professions), append a `search` parameter to narrow results on the server.

Request:

```http
GET /lookups?categorySlug=professions&search=eng
```

---

## Error Responses

| Status | Meaning                                    |
| ------ | ------------------------------------------ |
| `400`  | Missing or invalid `categorySlug`          |
| `401`  | Unauthenticated � token missing or expired |
| `404`  | Category slug not found                    |
| `500`  | Internal server error                      |

---

## Key Conventions

- **Store keys, display labels.** The `key` field is the stable identifier. The `label` field is for display only and may change over time.
- **Dynamic community slugs.** Community options depend on the user's selected religion. The slug equals the religion value in lowercase (e.g. `islam`, `christianity`).
- **Optional search.** The `search` parameter is supported for large categories. If a category does not support search, the full list is returned regardless.
- **Category not found.** If an unknown slug is requested, the API should return `404` or an empty `data` array � handle both gracefully.

---

## Static Enums Reference

Some field values are **static** — they are fixed in the application and do not come from the Lookups API. These must be sent exactly as shown below (case-sensitive).

> **Dynamic vs static:** Use the Lookups API for professions, communities, income ranges, education levels, and hobbies. Use the static enums below for all other fields.

---

### User Basics

#### Gender

Field: `gender`

| Value    |
| -------- |
| `male`   |
| `female` |

---

#### Profile For

Field: `profileFor`

| Value      |
| ---------- |
| `self`     |
| `son`      |
| `daughter` |
| `brother`  |
| `sister`   |
| `friend`   |
| `relative` |

---

#### Profile Managed By

Field: `profileManagedBy`

| Value      |
| ---------- |
| `self`     |
| `parent`   |
| `sibling`  |
| `relative` |
| `friend`   |
| `other`    |

---

#### Marital Status

Field: `maritalStatus`

| Value              |
| ------------------ |
| `never_married`    |
| `married`          |
| `divorced`         |
| `widowed`          |
| `separated`        |
| `awaiting_divorce` |

---

#### Verification Type

Field: `verificationType`

| Value   |
| ------- |
| `email` |
| `phone` |

---

#### Verify Purpose Type

Field: `verifyPurposeType` — used in OTP/verification flows

| Value             |
| ----------------- |
| `signin`          |
| `signup`          |
| `password_reset`  |
| `password_create` |
| `update_contact`  |

---

#### Registration Source

Field: `registrationSource`

| Value      |
| ---------- |
| `organic`  |
| `google`   |
| `facebook` |

---

### Religion

#### Religion

Field: `religion`

| Value          |
| -------------- |
| `islam`        |
| `hinduism`     |
| `christianity` |
| `buddhism`     |
| `others`       |

> After a religion value is selected, use it as the `categorySlug` in a Lookups API call to fetch community options for that religion.

---

#### Religious Background

Field: `religiousBackground`

| Value                     |
| ------------------------- |
| `very_religious`          |
| `religious`               |
| `somewhat_religious`      |
| `not_religious`           |
| `spiritual_not_religious` |

---

### Physical Attributes

#### Diet

Field: `diet`

| Value                  |
| ---------------------- |
| `vegetarian`           |
| `non_vegetarian`       |
| `halal_only`           |
| `vegan`                |
| `jain_vegetarian`      |
| `occasionally_non_veg` |

---

#### Blood Group

Field: `bloodGroup`

| Value     |
| --------- |
| `A+`      |
| `A-`      |
| `B+`      |
| `B-`      |
| `AB+`     |
| `AB-`     |
| `O+`      |
| `O-`      |
| `unknown` |

---

#### Complexion

Field: `complexion`

| Value            |
| ---------------- |
| `fair`           |
| `very_fair`      |
| `wheatish`       |
| `wheatish_brown` |
| `dark`           |

---

#### Health Condition

Field: `healthCondition`

| Value                 |
| --------------------- |
| `normal`              |
| `any_illness`         |
| `disability`          |
| `special_requirement` |

---

### Location & Residency

#### Residency Status

Field: `residencyStatus`

| Value                |
| -------------------- |
| `citizen`            |
| `permanent_resident` |
| `work_permit`        |
| `student_visa`       |
| `temporary_visa`     |
| `visitor`            |

---

### Career & Income

#### Work Type

Field: `workType`

| Value                      |
| -------------------------- |
| `open_to_all`              |
| `business_self_employed`   |
| `private_company`          |
| `government_public_sector` |
| `defense_civil_service`    |
| `not_working`              |

---

#### Income Frequency

Field: `incomeFrequency`

| Value     |
| --------- |
| `monthly` |
| `yearly`  |

---

### Education

#### Education Preference

Field: `educationPreference` — used in partner preference forms

| Value                 |
| --------------------- |
| `open_to_all`         |
| `no_formal_education` |
| `primary`             |
| `secondary`           |
| `higher_secondary`    |
| `diploma`             |
| `bachelor`            |
| `masters`             |
| `phd`                 |
| `doctorate`           |
| `professional_degree` |
| `vocational_training` |
| `certificate`         |
| `others`              |

> For displaying education level options in profile and search forms, also see the `education-levels` Lookups API category.

---

### Family

#### Family Type

Field: `familyType`

| Value     |
| --------- |
| `nuclear` |
| `joint`   |
| `others`  |

---

#### Family Values

Field: `familyValues`

| Value         |
| ------------- |
| `traditional` |
| `moderate`    |
| `liberal`     |

---

#### Family Economic Condition

Field: `familyEconomicCondition`

| Value                |
| -------------------- |
| `elite_class`        |
| `upper_class`        |
| `middle_class`       |
| `lower_middle_class` |

---

#### Family Marital Status

Field: `maritalStatus` (used in sibling/family member sub-objects)

| Value      |
| ---------- |
| `single`   |
| `married`  |
| `divorced` |
| `widowed`  |

---

### Lifestyle & Life Preferences

#### Height Unit

Field: `heightUnit`

| Value |
| ----- |
| `cm`  |
| `ft`  |

---

#### Post Marriage Living (own profile)

Field: `postMarriageLiving` — the user's own living arrangement preference on their profile/biodata

| Value         |
| ------------- |
| `with_family` |
| `individual`  |
| `abroad`      |

---

#### Post Marriage Living Preference (partner search)

Field: `postMarriageLivingPreference` — used in partner preference / search filter forms

| Value         |
| ------------- |
| `with_family` |
| `separate`    |
| `flexible`    |
| `near_family` |

---

#### Spouse Work / Study

Field: `spouseWorkStudy`

| Value      |
| ---------- |
| `yes`      |
| `no`       |
| `flexible` |

---

### Search Filter Enums

The following enums are used exclusively in search/filter API requests.

#### Distance

Field: `distance`

| Value |
| ----- |
| `50`  |
| `100` |
| `250` |
| `any` |

> Values represent kilometres. `any` removes the distance filter.

---

#### Match Type

Field: `matchType`

| Value             |
| ----------------- |
| `open_to_all`     |
| `two_way_matches` |

---

#### Recently Joined

Field: `recentlyJoined`

| Value             |
| ----------------- |
| `most_relevant`   |
| `open_to_all`     |
| `visible_to_all`  |
| `protected_photo` |

---

#### Active Members

Field: `activeMembers`

| Value                |
| -------------------- |
| `online_now`         |
| `active_within_24h`  |
| `active_within_week` |

---

#### Education Level (search filter)

Field: `educationLevel` — for filtering search results

| Value                 |
| --------------------- |
| `no_formal_education` |
| `primary`             |
| `secondary`           |
| `higher_secondary`    |
| `diploma`             |
| `bachelor`            |
| `masters`             |
| `phd`                 |
| `professional_degree` |
| `vocational_training` |
| `open_to_all`         |

---

#### Have Children

Field: `haveChildren`

| Value                          |
| ------------------------------ |
| `no`                           |
| `yes`                          |
| `okay_if_not_staying_together` |

---

#### Belong With Family

Field: `belongWithFamily`

| Value |
| ----- |
| `yes` |
| `no`  |

---

#### Photo Visibility

Field: `photoVisibility`

| Value            |
| ---------------- |
| `visible_to_all` |
| `private_photo`  |

---

#### Response Format

Field: `responseFormat`

| Value   |
| ------- |
| `short` |
| `full`  |

---

## Quick Reference: API vs Static Enum

| Data                 | Source      | How to get values                            |
| -------------------- | ----------- | -------------------------------------------- |
| Communities / sects  | Lookups API | `GET /lookups?categorySlug={religion}`       |
| Professions          | Lookups API | `GET /lookups?categorySlug=professions`      |
| Income ranges        | Lookups API | `GET /lookups?categorySlug=income-range`     |
| Education levels     | Lookups API | `GET /lookups?categorySlug=education-levels` |
| Hobbies & interests  | Lookups API | Six hobby slugs listed above                 |
| Gender               | Static enum | See Enums Reference above                    |
| Marital status       | Static enum | See Enums Reference above                    |
| Religion             | Static enum | See Enums Reference above                    |
| Religious background | Static enum | See Enums Reference above                    |
| Diet                 | Static enum | See Enums Reference above                    |
| Blood group          | Static enum | See Enums Reference above                    |
| Work type            | Static enum | See Enums Reference above                    |
| Family type/values   | Static enum | See Enums Reference above                    |
| Residency status     | Static enum | See Enums Reference above                    |
| Search filter fields | Static enum | See Search Filter Enums above                |
