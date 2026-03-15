import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/login/data/models/resend_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_otp_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/sign_up_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_interests_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/update_family_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/onboarding_response.dart';
import 'package:flutter_boilerplate/features/registration/data/models/response/upload_media_response.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/interests_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/family_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/location_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/media_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/religion_data_repository_impl.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/registration_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/religion_option_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/religion_data_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/is_with_family_status_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/profile_for_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchMatchesProvider extends BaseChangeNotifier {
    SearchMatchesScreenStates screenStates = SearchMatchesScreenStates.defaultLoading;

    final TextEditingController ageFromController = TextEditingController();
    final TextEditingController ageToController = TextEditingController();
    final TextEditingController heightFromController = TextEditingController();
    final TextEditingController heightToController = TextEditingController();
    final TextEditingController maritalStatusController = TextEditingController();
    final TextEditingController religionController = TextEditingController();
    final TextEditingController communityController = TextEditingController();
    final TextEditingController motherTongueController = TextEditingController();
    final TextEditingController countryLivingController = TextEditingController();
    final TextEditingController stateLivingController = TextEditingController();
    final TextEditingController grewUpController = TextEditingController();
    final TextEditingController residencyStatusController = TextEditingController();
    final TextEditingController photoSettingController = TextEditingController();


    List<SingleStringModel> ageRangeDropdownItems = ageListDataInserted;
}

enum SearchMatchesScreenStates {
  defaultLoading,
  loadingComplete,
  isProfileFor,
}
