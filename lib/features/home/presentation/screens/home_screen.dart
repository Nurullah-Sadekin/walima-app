import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/providers/theme_provider.dart';
import 'package:flutter_boilerplate/core/providers/locale_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 10,
            children: [
              Buttons(buttonStyle: ButtonsStyle.activePrimaryButton, onTap: () {},title: 'Active Primary Button',),
              Buttons(buttonStyle: ButtonsStyle.disableButton, onTap: () {},title: 'Disable Button',),
              Buttons(buttonStyle: ButtonsStyle.activeSecondaryButton, onTap: () {},title: 'Active Secondary Button',),
              Buttons(buttonStyle: ButtonsStyle.cancelButton, onTap: () {},title: 'Cancel',),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(child: Buttons(style: ButtonsStyle.activePrimaryButton, onTap: () {},title: 'Continue',)),
              //
              //     Expanded(child: Buttons(style: ButtonsStyle.activeSecondaryButton, onTap: () {},title: 'Continue',)),
              //   ],
              // ),
              Buttons(buttonStyle: ButtonsStyle.iconicDynamicButton, onTap: () {},title: 'Continue',icon: const Icon(Icons.arrow_forward,size: 15,),borderColor: Colors.green,textColor: AppColors.primary,iconLeftPosition: false),

            ],
          ),
        ),
      ),
    );
  }

}
