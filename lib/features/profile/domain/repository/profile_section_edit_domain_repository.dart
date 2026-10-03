import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/features/profile/data/model/request/update_profile_section_request_body.dart';
import 'package:walima_llc/features/profile/data/model/response/update_profile_section_response.dart';
import 'package:walima_llc/features/profile/data/repository/profile_repository.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';

abstract class ProfileSectionEditDomainRepository {
  Future<List<LookupOption>> getLookupsBySlug(
    String categorySlug, {
    String? search,
  });

  Future<List<LookupOption>> getLookups(
    LookupCategory category, {
    String? search,
  });

  Future<UpdateProfileSectionResponse> updateUniversalProfile(
    UpdateProfileSectionRequestBody body,
  );
}

class ProfileSectionEditDomainRepositoryImpl
    implements ProfileSectionEditDomainRepository {
  ProfileSectionEditDomainRepositoryImpl({
    LookupRepository? lookupRepository,
  }) : _lookupRepository = lookupRepository ?? LookupRepository();

  final LookupRepository _lookupRepository;

  @override
  Future<List<LookupOption>> getLookupsBySlug(
    String categorySlug, {
    String? search,
  }) {
    return _lookupRepository.getLookupsBySlug(categorySlug, search: search);
  }

  @override
  Future<List<LookupOption>> getLookups(
    LookupCategory category, {
    String? search,
  }) {
    return _lookupRepository.getLookups(category, search: search);
  }

  @override
  Future<UpdateProfileSectionResponse> updateUniversalProfile(
    UpdateProfileSectionRequestBody body,
  ) {
    return ProfileRepository.updateUniversalProfile(body);
  }
}
