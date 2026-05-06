import 'package:walima_llc/features/registration/domain/religion_option_model.dart';

abstract class ReligionDataRepository {
  Future<List<ReligionOptionModel>> getReligionOptions();

  Future<List<String>> getReligionNames();

  Future<List<String>> getCommunityOptions({
    required String religion,
    bool flattenNested = true,
    bool includeCategoryKeys = false,
  });
}
