import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
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
    final TextEditingController _emailController = TextEditingController();
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
              Buttons(buttonStyle: ButtonsStyle.iconicDynamicButton, onTap: () {},title: 'Iconic Dynamic Button',icon: const Icon(Icons.arrow_forward,size: 15,),borderColor: Colors.green,textColor: AppColors.primary,iconLeftPosition: false),
              Buttons(buttonStyle: ButtonsStyle.authButton, onTap: () {},title: 'Auth Dynamic Button',icon: const Icon(Icons.arrow_forward,size: 15,),borderColor: Colors.green,textColor: AppColors.primary),
              PrimaryTextField(
                controller: _emailController,
                headLine: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                onChanged: (value) {

                  }, errorText: null, onTap: () {  },
                suffix: const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
              PrimaryTextField(
                controller: _emailController,
                headLine: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                onChanged: (value) {

                }, errorText: null, onTap: () {  },
                datePicker: true,
                readOnly: true,
                prefixIcon: Icons.calendar_month,
              ),
              PrimaryTextField(
                controller: _emailController,
                hintText: 'Enter your password',
                noPrefix: true,
                onChanged: (value) {

                }, errorText: null, onTap: () {  },
                showPassIcon: true,
                forgotPass: true,
              ),
              DropDownField(
                headLine: 'Select Country',
                hintText: 'Choose your country',
                items: ['USA', 'Canada', 'UK', 'Australia'],
                controller: _emailController,
                onTap: () {  }, popUpHeader: '', isSearch: true,
              ),

            ],
          ),
        ),
      ),
    );
  }

}
