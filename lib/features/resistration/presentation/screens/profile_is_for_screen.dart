import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/profile_type_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
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
            :  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  ShowImage(
                    imagePath: AppImages.isProfileFor,
                    width: 110,
                    height: 110,
                  ),
                  Column(
                    spacing: 10,
                    children: List.generate(provider.profileForList.length, (index) {
                      final isProfileFor = provider.profileForList[index];
                      return IsProfileForItemWidget(
                        title: isProfileFor.name ,
                        imagePath: isProfileFor.emoji,
                        isSelected: isProfileFor.isSelected,
                        onTap: () {
                         // selectedIndex = index;
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
