import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/profile_preview/data/models/profile_preview_response.dart';

void main() {
  test('parses the documented full match-preview response', () {
    final response = ProfilePreviewResponse.fromJson(<String, dynamic>{
      'code': 'SUCCESS',
      'response': <String, dynamic>{
        'data': <String, dynamic>{
          'user': <String, dynamic>{
            'id': 'member-1',
            'firstName': 'Onamika',
            'lastName': 'Oishee',
          },
          'profile': <String, dynamic>{
            'gender': 'female',
            'aboutMe': 'Engineer',
            'religion': 'islam',
            'community': 'sunni',
            'appearance': <String, dynamic>{'height': 165},
          },
          'lifestyle': <String, dynamic>{'dietType': 'halal_only'},
          'educations': <Map<String, dynamic>>[
            <String, dynamic>{
              'educationLevel': 'bachelor',
              'degree': 'B.Sc. in Computer Science',
              'institution': 'University of Dhaka',
            },
          ],
          'professions': <Map<String, dynamic>>[
            <String, dynamic>{
              'profession': 'software_engineer',
              'annualIncome': '৳10,00,000 - ৳15,00,000',
            },
          ],
          'galleryImages': <Map<String, dynamic>>[
            <String, dynamic>{
              'url': 'https://cdn.walima.app/gallery-1.webp',
              'isPrimary': true,
            },
          ],
          'matchNarrative': 'You share aligned values.',
        },
      },
    });

    final preview = response.data!;
    expect(response.isSuccess, isTrue);
    expect(preview.about, 'Engineer');
    expect(preview.profile!.height, 165);
    expect(preview.profile!.religionName, 'islam');
    expect(preview.lifestyle!.diet, 'halal_only');
    expect(preview.educations!.fieldOfStudy, 'B.Sc. in Computer Science');
    expect(preview.professions!.workingAs, 'software_engineer');
    expect(
        preview.galleryImages.single, 'https://cdn.walima.app/gallery-1.webp');
    expect(preview.matchNarrative, 'You share aligned values.');
  });
}
