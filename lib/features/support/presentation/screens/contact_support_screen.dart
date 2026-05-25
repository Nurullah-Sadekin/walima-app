import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class ContactSupportScreen extends ConsumerWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(supportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Stack(
        children: [
          Column(
            children: [
              CustomBackAppBar(
                title: Text('Contact Support'.localized(context)),
                onBackPressed: () => context.pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  children: [
                    Text(
                      'Need Help?'.localized(context),
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                        fontSize: TextSize.font18(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "We're here to help you on your journey to finding the right match."
                          .localized(context),
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.font14(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TextField(
                      label: 'Email (optional)',
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      label: 'Phone (optional)',
                      controller: provider.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      label: 'Subject',
                      controller: provider.subjectController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _TextField(
                      label: 'Message',
                      controller: provider.messageController,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                    ),
                    if (provider.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        provider.errorMessage!.localized(context),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.canSubmit
                          ? () async {
                              final success =
                                  await ref.read(supportProvider).submit();
                              if (!success || !context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Your message has been sent.'
                                        .localized(context),
                                  ),
                                ),
                              );
                              context.pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          provider.isSubmitting
                              ? 'Sending...'.localized(context)
                              : 'Send'.localized(context),
                          style: TextStyle(
                            fontSize: TextSize.font16(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (provider.isSubmitting)
            Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const Loading(),
            ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.localized(context),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
            fontSize: TextSize.font12(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE6ECE9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE6ECE9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
