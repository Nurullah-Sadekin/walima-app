import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';

void main() {
  setUpAll(AppConfig.initialize);

  test('local shortlist toggles by profile ID and resets for another user', () {
    final provider = HomeProvider();
    provider.setAuthenticatedUser('user-1');

    provider.toggleShortlist('profile-1');
    expect(provider.isShortlisted('profile-1'), isTrue);
    expect(provider.isShortlisted('profile-2'), isFalse);

    provider.toggleShortlist('profile-1');
    expect(provider.isShortlisted('profile-1'), isFalse);

    provider.toggleShortlist('profile-1');
    provider.setAuthenticatedUser('user-2');
    expect(provider.isShortlisted('profile-1'), isFalse);
  });
}
