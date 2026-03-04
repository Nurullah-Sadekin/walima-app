import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/resistration/presentation/providers/resistration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsProfileForScreen extends ConsumerStatefulWidget {
  const IsProfileForScreen({super.key});
  @override
  ConsumerState<IsProfileForScreen> createState() => _IsProfileForScreenState();
}

class _IsProfileForScreenState extends ConsumerState<IsProfileForScreen> {
  late RegistrationProvider provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Is Profile For'),
        ),
        body: provider.screenStates == RegistrationScreenStates.isProfileFor
            ? const Loading()
            : const Center(
                child: Text('Is Profile For Screen'),
              ),
      ),
    );
  }
}
