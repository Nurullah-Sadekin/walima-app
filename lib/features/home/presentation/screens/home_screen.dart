import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/profile_type_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final TextEditingController emailController = TextEditingController();
    int selectedIndex = 0;
    final moodList = [
      {
        "title": "Myself",
        "image": "assets/icons/me.png",
      },
      {
        "title": "My Son",
        "image": "assets/icons/me.png",
      },
    ];
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
              Buttons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: () {},
                title: 'Active Primary Button',
              ),
              Buttons(
                buttonStyle: ButtonsStyle.disableButton,
                onTap: () {},
                title: 'Disable Button',
              ),
              Buttons(
                buttonStyle: ButtonsStyle.activeSecondaryButton,
                onTap: () {},
                title: 'Active Secondary Button',
              ),
              Buttons(
                buttonStyle: ButtonsStyle.cancelButton,
                onTap: () {},
                title: 'Cancel',
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(child: Buttons(style: ButtonsStyle.activePrimaryButton, onTap: () {},title: 'Continue',)),
              //
              //     Expanded(child: Buttons(style: ButtonsStyle.activeSecondaryButton, onTap: () {},title: 'Continue',)),
              //   ],
              // ),
              Buttons(
                  buttonStyle: ButtonsStyle.iconicDynamicButton,
                  onTap: () {},
                  title: 'Iconic Dynamic Button',
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 15,
                  ),
                  borderColor: Colors.green,
                  textColor: AppColors.primary,
                  iconLeftPosition: false),
              Buttons(
                  buttonStyle: ButtonsStyle.authButton,
                  onTap: () {},
                  title: 'Auth Dynamic Button',
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 15,
                  ),
                  borderColor: Colors.green,
                  textColor: AppColors.primary),
              PrimaryTextField(
                controller: emailController,
                headLine: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                onChanged: (value) {},
                errorText: null,
                onTap: () {},
                suffix: const Icon(Icons.check_circle,
                    color: Colors.green, size: 20),
              ),
              PrimaryTextField(
                controller: emailController,
                headLine: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                onChanged: (value) {},
                errorText: null,
                onTap: () {},
                datePicker: true,
                readOnly: true,
                prefixIcon: Icons.calendar_month,
              ),
              PrimaryTextField(
                controller: emailController,
                hintText: 'Enter your password',
                noPrefix: true,
                onChanged: (value) {},
                errorText: null,
                onTap: () {},
                showPassIcon: true,
                forgotPass: true,
              ),
              DropDownField(
                headLine: 'Select Country',
                hintText: 'Choose your country',
                popUpHeader: 'Select Country',
                items: const ['USA', 'Canada', 'UK', 'Australia'],
                controller: emailController,
                onTap: () {},
                isSearch: true,
              ),
              Column(
                children: List.generate(moodList.length, (index) {
                  final mood = moodList[index];
                  return MoodItemWidget(
                    title: mood['title'] ?? '',
                    imagePath: mood['image'] ?? '',
                    isSelected: selectedIndex == index,
                    onTap: () {
                      selectedIndex = index;
                    },
                  );
                }),
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: MoodItemWidget(
                      title: moodList[0]['title'] ?? '', // Access first item's title
                      imagePath: moodList[0]['image'] ?? '', // Access first item's image
                      isSelected: selectedIndex == 0, onTap: () {  },

                    ),
                  ),
                  Expanded(
                    child: MoodItemWidget(
                      title: moodList[1]['title'] ?? '', // Access first item's title
                      imagePath: moodList[1]['image'] ?? '', // Access first item's image
                      isSelected: selectedIndex == 1, onTap: () {  },

                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
