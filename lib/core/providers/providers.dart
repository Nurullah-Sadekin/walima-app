import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider();
});

final registrationProvider = ChangeNotifierProvider<RegistrationProvider>((ref) {
  return RegistrationProvider();
});

