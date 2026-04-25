import 'dart:convert';

import 'package:flutter_boilerplate/core/global/models/limit_info.dart';
import 'package:flutter_boilerplate/core/global/models/refresh_token_request_body.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/login/data/models/get_me_response_body.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';
import 'package:flutter_boilerplate/features/login/data/repository/login_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GlobalRepository {


  Future<String> getAppVersion() async {
    await Future.delayed(const Duration(seconds: 1));
      final packageInfo = await PackageInfo.fromPlatform();
      final versionText = 'Version: ${packageInfo.version}.${packageInfo.buildNumber}';
      return versionText;

  }

  Future<GetMeResponseBody> fetchMe() async {
    return LoginRepository.getMe();
  }

  Future<void> cacheMeSnapshot(GetMeResponseBody response) async {
    await PrefsHelper.setMeSnapshot(json.encode(response.toJson()));
    await cacheQuotaSnapshot(_extractLimitList(response));
  }

  Future<void> cacheQuotaSnapshot(List<LimitInfo> quotas) async {
    await PrefsHelper.setQuotaSnapshot(
      json.encode(quotas.map((item) => item.toJson()).toList()),
    );
  }

  Future<GetMeResponseBody?> getCachedMeSnapshot() async {
    final raw = await PrefsHelper.getMeSnapshot();
    if (raw.isEmpty) return null;
    try {
      return GetMeResponseBody.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<LimitInfo>> getCachedQuotaSnapshot() async {
    final raw = await PrefsHelper.getQuotaSnapshot();
    if (raw.isEmpty) return const <LimitInfo>[];
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(LimitInfo.fromJson)
          .toList();
    } catch (_) {
      return const <LimitInfo>[];
    }
  }

  List<LimitInfo> extractLimits(GetMeResponseBody response) {
    return _extractLimitList(response);
  }

  Future<void> clearCachedSessionState() async {
    await PrefsHelper.clearMeSnapshot();
    await PrefsHelper.clearQuotaSnapshot();
  }

  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await PrefsHelper.getRefreshToken();
      if (refreshToken.isEmpty) {
        return false;
      }

      final requestBody = RefreshRequestBody(refreshToken: refreshToken);
      final response = await DioClient()
          .post(AppUrls.getAccessToken, data: requestBody.toJson());
      final data = LoginResponse.fromJson(response.data);
      if (data.code == 'SUCCESS' && data.response != null) {
        final accessToken = data.response?.accessToken ?? '';
        final newRefreshToken = data.response?.refreshToken ?? '';

        await PrefsHelper.setAccessToken(accessToken);
        await PrefsHelper.setRefreshToken(newRefreshToken);

        if (accessToken.isNotEmpty) {
          DioClient().setAuthToken(accessToken);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  List<LimitInfo> _extractLimitList(GetMeResponseBody response) {
    final features =
        response.response?.user?.premium?.features ?? const <Features>[];
    return features
        .map(
          (feature) => LimitInfo(
            key: feature.key,
            name: feature.name,
            displayOrder: feature.displayOrder,
            valueType: feature.valueType,
            used: feature.used ?? 0,
            limit: feature.limit,
            remaining: feature.remaining,
            isUnlimited: feature.isUnlimited ?? false,
            resetDate: feature.resetDate,
            resetPeriod: feature.resetPeriod,
            tierValue: feature.tierValue,
          ),
        )
        .toList()
      ..sort(
        (a, b) => (a.displayOrder ?? 9999).compareTo(
          b.displayOrder ?? 9999,
        ),
      );
  }
}
