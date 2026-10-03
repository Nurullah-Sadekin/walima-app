import 'package:intl/intl.dart';
import 'package:walima_llc/features/biodata/domain/model/biodata_document.dart';

class BiodataFormatter {
  const BiodataFormatter._();

  static BiodataDocument fromApi(Map<String, dynamic> source) {
    final profile = _map(source['profile']);
    final appearance = _map(source['appearance']);
    final religion = _map(source['religion']);
    final lifestyle = _map(source['lifestyle']);
    final family = _map(source['family']);
    final preferences = _map(source['preferences']);
    final user = _map(source['user']);

    final locations = _list(source['locations']);
    final educations = _list(source['educations']);
    final professions = _resolveProfessions(source);
    final contacts = _list(source['contacts']);
    final profilePictures = _list(profile['profilePictures']);

    final primaryLocation = _locationText(locations, 'present') ??
        _locationText(locations, 'permanent') ??
        '';
    final permanentLocation = _locationText(locations, 'permanent') ??
        _locationText(locations, 'present') ??
        '';
    final primaryEducation = _firstUseful(educations, [
      'isHighestLevel',
      'educationLevel',
      'institutionName',
    ]);
    final primaryProfession =
        professions.isNotEmpty ? professions.first : const <String, dynamic>{};

    final email = _contactValue(contacts, 'email');
    final phone = _contactValue(contacts, 'phone');
    final photoUrl = _firstPrimaryPhoto(profilePictures) ??
        _firstPrimaryPhoto(_list(source['photos'])) ??
        '';

    final fullName = _text(profile['displayName']).isNotEmpty
        ? _text(profile['displayName'])
        : [_text(user['firstName']), _text(user['lastName'])]
            .where((part) => part.isNotEmpty)
            .join(' ');

    return BiodataDocument(
      fullName: fullName,
      profileImageUrl: photoUrl,
      bio: _text(source['about']).isNotEmpty
          ? _text(source['about'])
          : _text(profile['bio']),
      sections: [
        BiodataSection(
          title: 'Personal Information',
          items: _items([
            _item('Date of Birth', _dateWithAge(profile['dateOfBirth'])),
            _item('Gender', profile['gender'] ?? source['gender']),
            _item('Marital Status', profile['maritalStatus']),
            _item('Height', _height(profile['height'] ?? appearance['height'])),
            _item('Weight', _withUnit(appearance['weight'], 'kg')),
            _item('Complexion', appearance['complexion']),
            _item('Blood Group', appearance['bloodGroup']),
            _item('Religion', religion['religion'] ?? profile['religionName']),
            _item('Community', religion['community']),
            _item('Mother Tongue', profile['motherTongue']),
            _item(
              'Food Habits',
              lifestyle['diet'] ?? lifestyle['dietType'] ?? profile['diet'],
            ),
            _item('Health Condition', appearance['healthCondition']),
            _item('Hobbies', _interests(source['interests'])),
          ]),
        ),
        BiodataSection(
          title: 'Location',
          items: _items([
            _item('Present Address', primaryLocation),
            _item('Permanent Address', permanentLocation),
          ]),
        ),
        BiodataSection(
          title: 'Education',
          items: _items([
            _item(
              'Highest Academic Qualification',
              primaryEducation['educationLevel'] ??
                  primaryEducation['highestAcademicQualification'],
            ),
            _item('Institution', primaryEducation['institutionName']),
            _item('Passing Year', primaryEducation['passingYear']),
            _item(
              'Result',
              primaryEducation['qualification'] ?? primaryEducation['results'],
            ),
            _item(
              'Additional Courses',
              primaryEducation['additionalCoursesCertificates'] ??
                  primaryEducation['additionalCoursesCertifications'],
            ),
          ]),
        ),
        BiodataSection(
          title: 'Career & Financial',
          items: _items([
            _item(
              'Profession',
              primaryProfession['profession'] ?? primaryProfession['workingAs'],
            ),
            _item('Designation', primaryProfession['designation']),
            _item(
              'Organization',
              primaryProfession['employer'] ??
                  primaryProfession['employerName'],
            ),
            _item('Work Location', primaryProfession['workLocation']),
            _item('Annual Income', primaryProfession['incomeRange']),
          ]),
        ),
        BiodataSection(
          title: 'Family Details',
          items: _items([
            _item("Father's Name", family['fatherName']),
            _item(
              "Father's Profession",
              family['fatherProfession'] ?? family['fatherStatus'],
            ),
            _item("Mother's Name", family['motherName']),
            _item(
              "Mother's Profession",
              family['motherProfession'] ?? family['motherStatus'],
            ),
            _item(
              'Family Economic Condition',
              family['familyEconomicCondition'],
            ),
            _item('Family Income', family['familyIncome']),
            _item('Family Location', family['familyLocation']),
            _item('Ancestral Origin', family['ancestralOrigin']),
            _item('About Family', family['aboutFamily']),
          ]),
        ),
        BiodataSection(
          title: 'Partner Preferences',
          items: _items([
            _item('Expectations', preferences['expectationsFromLifePartner']),
            _item('Preferred Age Range', _range(preferences, 'age')),
            _item('Preferred Height Range', _range(preferences, 'height')),
            _item('Preferred Education', preferences['educationPreference']),
            _item('Preferred Profession', preferences['professionPreference']),
            _item(
              'Preferred Countries',
              preferences['preferredCountries'] ?? preferences['country'],
            ),
            _item(
              'Preferred Cities',
              preferences['preferredCities'] ?? preferences['city'],
            ),
            _item(
              'Work/Study After Marriage',
              preferences['spouseWorkStudyAllowed'],
            ),
            _item(
              'Post Marriage Living',
              preferences['postMarriageLivingPreference'],
            ),
          ]),
        ),
        BiodataSection(
          title: 'Contact',
          items: _items([
            _item(
              'Phone Number',
              _text(source['phone']).isNotEmpty ? source['phone'] : phone,
            ),
            _item(
              'Email',
              _text(source['email']).isNotEmpty ? source['email'] : email,
            ),
          ]),
        ),
      ].map(_withoutEmptySections).whereType<BiodataSection>().toList(),
    );
  }

  static BiodataSection? _withoutEmptySections(BiodataSection section) {
    if (section.items.isEmpty) return null;
    return section;
  }

  static BiodataItem _item(String label, Object? value) {
    return BiodataItem(label: label, value: _format(value));
  }

  static List<BiodataItem> _items(List<BiodataItem> items) {
    return items.where((item) => item.value.isNotEmpty).toList();
  }

  static Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static List<Map<String, dynamic>> _list(Object? value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static List<Map<String, dynamic>> _resolveProfessions(
    Map<String, dynamic> source,
  ) {
    final profession = source['profession'];
    if (profession is List) return _list(profession);
    final professions = source['professions'];
    if (professions is List) return _list(professions);
    if (professions is Map) return [Map<String, dynamic>.from(professions)];
    return const <Map<String, dynamic>>[];
  }

  static Map<String, dynamic> _firstUseful(
    List<Map<String, dynamic>> items,
    List<String> keys,
  ) {
    if (items.isEmpty) return const <String, dynamic>{};
    for (final item in items) {
      if (item['isHighestLevel'] == true) return item;
    }
    return items.firstWhere(
      (item) => keys.any((key) => _text(item[key]).isNotEmpty),
      orElse: () => items.first,
    );
  }

  static String? _locationText(
    List<Map<String, dynamic>> locations,
    String type,
  ) {
    final matched = locations.where((location) {
      return _text(location['locationType']).toLowerCase() == type;
    }).toList();
    final item = matched.isNotEmpty ? matched.first : null;
    if (item == null) return null;
    final fullAddress = _text(item['fullAddress']);
    if (fullAddress.isNotEmpty) return fullAddress;
    return [
      item['locality'],
      item['city'],
      item['district'],
      item['state'],
      item['country'],
    ].map(_text).where((value) => value.isNotEmpty).join(', ');
  }

  static String _contactValue(
    List<Map<String, dynamic>> contacts,
    String type,
  ) {
    for (final contact in contacts) {
      if (_text(contact['contactType']).toLowerCase() == type) {
        return _text(contact['contactValue']);
      }
    }
    return '';
  }

  static String? _firstPrimaryPhoto(List<Map<String, dynamic>> photos) {
    if (photos.isEmpty) return null;
    final primary = photos.where((photo) => photo['isPrimary'] == true);
    return _text((primary.isNotEmpty ? primary.first : photos.first)['url']);
  }

  static String _dateWithAge(Object? value) {
    final raw = _text(value);
    if (raw.isEmpty) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    final now = DateTime.now();
    var age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return '${DateFormat('dd MMM yyyy').format(date)} ($age Years)';
  }

  static String _height(Object? value) {
    final cm = double.tryParse(_text(value));
    if (cm == null || cm <= 0) return _text(value);
    final totalInches = (cm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet ft $inches in';
  }

  static String _withUnit(Object? value, String unit) {
    final text = _text(value);
    if (text.isEmpty) return '';
    return '$text $unit';
  }

  static String _range(Map<String, dynamic> source, String prefix) {
    final nested = _map(source['${prefix}Range']);
    final min = _text(nested['min']).isNotEmpty
        ? _text(nested['min'])
        : _text(source['${prefix}Min']);
    final max = _text(nested['max']).isNotEmpty
        ? _text(nested['max'])
        : _text(source['${prefix}Max']);
    if (min.isEmpty || max.isEmpty) return '';
    return '$min - $max';
  }

  static String _interests(Object? value) {
    final interests = _map(value);
    return interests.values
        .whereType<List>()
        .expand((items) => items)
        .map(_text)
        .where((item) => item.isNotEmpty)
        .take(8)
        .join(', ');
  }

  static String _format(Object? value) {
    if (value is List) {
      return value.map(_text).where((item) => item.isNotEmpty).join(', ');
    }
    return _humanize(_text(value));
  }

  static String _text(Object? value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static String _humanize(String value) {
    if (value.isEmpty) return '';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) {
      if (part.length == 1) return part.toUpperCase();
      return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
    }).join(' ');
  }
}
