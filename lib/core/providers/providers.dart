import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider<LoginProviderNotifier>((ref) {
  return LoginProviderNotifier();
});

