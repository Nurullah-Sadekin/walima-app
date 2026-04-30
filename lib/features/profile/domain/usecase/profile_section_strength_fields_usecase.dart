import 'package:flutter_boilerplate/features/home/data/model/response/profile_strength_response.dart';

class ProfileSectionStrengthFieldsUseCase {
  const ProfileSectionStrengthFieldsUseCase();

  List<ProfileStrengthField> resolveEffectiveFields(
    List<ProfileStrengthField> fields,
  ) {
    final incomplete = fields
        .where(
          (field) =>
              field.completed != true &&
              (field.key?.trim().isNotEmpty ?? false),
        )
        .toList(growable: false);
    if (incomplete.isNotEmpty) {
      return incomplete;
    }

    return fields
        .where((field) => field.key?.trim().isNotEmpty ?? false)
        .toList(growable: false);
  }
}
