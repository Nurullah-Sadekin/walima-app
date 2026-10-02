// Models for the member shortlist API (SHORTLIST_API_GUIDE.md).
// Envelope: `{ code, message, response: { data, pagination? }, traceId }`.

/// `response.data` of add / remove / status.
class ShortlistAction {
  const ShortlistAction({
    required this.shortlisted,
    required this.targetUserId,
    this.shortlistedAt,
  });

  factory ShortlistAction.fromJson(Map<String, dynamic> json) {
    return ShortlistAction(
      shortlisted: json['shortlisted'] == true,
      targetUserId: json['targetUserId']?.toString() ?? '',
      shortlistedAt: DateTime.tryParse(json['shortlistedAt']?.toString() ?? ''),
    );
  }

  final bool shortlisted;
  final String targetUserId;
  final DateTime? shortlistedAt;
}

/// One profile from the shortlist list. Optional values may be null.
class ShortlistedMember {
  const ShortlistedMember({
    required this.id,
    this.userReference,
    this.displayName,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
    this.age,
    this.height,
    this.gender,
    this.profession,
    this.city,
    this.state,
    this.country,
    this.shortlistedAt,
  });

  factory ShortlistedMember.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final loc = location is Map ? location : const {};
    return ShortlistedMember(
      id: json['id']?.toString() ?? '',
      userReference: _str(json['userReference']),
      displayName: _str(json['displayName']),
      firstName: _str(json['firstName']),
      lastName: _str(json['lastName']),
      profilePictureUrl: _str(json['profilePictureUrl']),
      age: (json['age'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toDouble(),
      gender: _str(json['gender']),
      profession: _str(json['profession']),
      city: _str(loc['city']),
      state: _str(loc['state']),
      country: _str(loc['country']),
      shortlistedAt: DateTime.tryParse(json['shortlistedAt']?.toString() ?? ''),
    );
  }

  final String id;
  final String? userReference;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePictureUrl;
  final int? age;
  final double? height;
  final String? gender;
  final String? profession;
  final String? city;
  final String? state;
  final String? country;
  final DateTime? shortlistedAt;

  String get name {
    if (displayName != null) return displayName!;
    final full = [firstName, lastName].whereType<String>().join(' ').trim();
    return full.isEmpty ? 'Walima Member' : full;
  }

  String? get locationText {
    final parts = [city, country].whereType<String>().toList();
    return parts.isEmpty ? null : parts.join(', ');
  }
}

class ShortlistPagination {
  const ShortlistPagination({
    required this.total,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory ShortlistPagination.fromJson(Map<String, dynamic>? json) {
    final j = json ?? const <String, dynamic>{};
    int read(String key, int fallback) =>
        (j[key] as num?)?.toInt() ?? fallback;
    return ShortlistPagination(
      total: read('total', 0),
      page: read('page', 1),
      size: read('size', 0),
      totalPages: read('totalPages', 0),
      hasNextPage: j['hasNextPage'] == true,
    );
  }

  final int total;
  final int page;
  final int size;
  final int totalPages;
  final bool hasNextPage;
}

class ShortlistPage {
  const ShortlistPage({required this.members, required this.pagination});

  final List<ShortlistedMember> members;
  final ShortlistPagination pagination;
}

String? _str(dynamic value) {
  if (value == null) return null;
  final s = value.toString().trim();
  return s.isEmpty ? null : s;
}
