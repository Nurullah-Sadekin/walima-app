import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/icon_text_row.dart';
import 'package:flutter_boilerplate/core/global/components/package_card.dart';
import 'package:flutter_boilerplate/core/global/components/preference_connect_card.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/profile_type_card.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';

class GradientBackground extends ConsumerWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradientColor,
  });
  final Widget child;
  final Gradient? gradientColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          gradient: gradientColor ?? AppColors.customBackgroundGradient,
        ),
        child: child,
      );
  }
}
