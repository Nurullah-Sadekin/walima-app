import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutYou extends ConsumerStatefulWidget {
  const AboutYou({super.key});
  @override
  ConsumerState<AboutYou> createState() => _IsProfileForScreenState();
}

class _IsProfileForScreenState extends ConsumerState<AboutYou> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
