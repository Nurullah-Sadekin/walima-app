import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class HelpDeskScreen extends ConsumerWidget {
  const HelpDeskScreen({super.key});

  static const String _supportEmail = 'hello@walima.app';
  static const String _supportPhone = '+8801305455665';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Column(
        children: [
          CustomBackAppBar(
            title: Text('Help & Support'.localized(context)),
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Text(
                  'The Walima Help Desk'.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font24(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'How can we help you today? Browse popular topics, read our FAQ, or contact our support team directly.'.localized(context),
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.font14(context),
                  ),
                ),
                const SizedBox(height: 18),
                _SupportCard(
                  title: 'Live Chat Support',
                  subtitle: 'Chat with us live — get instant answers to your questions. No waiting, no queue.',
                  footnote: 'Available 10 AM – 10 PM (BST)',
                  primaryCta: 'Start Live Chat',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => context.pushNamed(Routes.aiSupport),
                ),
                const SizedBox(height: 16),
                _SupportCard(
                  title: 'Submit a Request',
                  subtitle: 'Email us at hello@walima.app and our team will respond within 24 hours.',
                  footnote: 'Average response: under 24 hours',
                  primaryCta: 'Send Email',
                  icon: Icons.mail_outline_rounded,
                  onTap: () => context.pushNamed(Routes.contactSupport),
                  secondaryAction: () async {
                    await _sendEmail();
                  },
                ),
                const SizedBox(height: 16),
                _SupportCard(
                  title: 'Call Us',
                  subtitle: 'Speak directly with our support team for urgent help or complex issues.',
                  footnote: '10 AM – 7 PM (BST) • Sat–Thu',
                  primaryCta: _supportPhone,
                  icon: Icons.call_outlined,
                  onTap: () async {
                    await _callNumber(_supportPhone);
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  'Popular Topics'.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font22(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Quick answers to the most common questions.'.localized(context),
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.font14(context),
                  ),
                ),
                const SizedBox(height: 14),
                const _TopicTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Account & Profile',
                  subtitle: 'Edit profile, change password, delete account, update photos',
                ),
                const SizedBox(height: 10),
                const _TopicTile(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Matches & Connections',
                  subtitle: 'How matching works, send interest, connect, block/unblock',
                ),
                const SizedBox(height: 10),
                const _TopicTile(
                  icon: Icons.school_outlined,
                  title: 'Premium & Payments',
                  subtitle: 'Upgrade plans, payment methods, refunds, subscription management',
                ),
                const SizedBox(height: 10),
                const _TopicTile(
                  icon: Icons.shield_outlined,
                  title: 'Safety & Privacy',
                  subtitle: 'Report misuse, block users, privacy settings, safe dating tips',
                ),
                const SizedBox(height: 10),
                const _TopicTile(
                  icon: Icons.chat_outlined,
                  title: 'Messages & Chat',
                  subtitle: 'Send messages, read receipts, chat limits, video calling',
                ),
                const SizedBox(height: 10),
                const _TopicTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Technical Issues',
                  subtitle: 'App not loading, login problems, notification issues, bugs',
                ),
                const SizedBox(height: 28),
                Text(
                  'Frequently Asked Questions'.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font22(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Can\'t find what you need? Contact us directly.'.localized(context),
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.font14(context),
                  ),
                ),
                const SizedBox(height: 14),
                const _FaqTile(title: 'How do I verify my profile?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'How do I upgrade to Premium?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'Can I get a refund?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'How do I delete my account?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'Why am I not getting matches?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'Is my data safe and private?'),
                const SizedBox(height: 10),
                const _FaqTile(title: 'What payment methods are accepted?'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.title,
    required this.subtitle,
    required this.primaryCta,
    required this.icon,
    required this.onTap,
    required this.footnote,
    this.secondaryAction,
  });

  final String title;
  final String subtitle;
  final String footnote;
  final String primaryCta;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0D6DD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            title.localized(context),
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w800,
              fontSize: TextSize.font20(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle.localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w400,
              fontSize: TextSize.font14(context),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(primaryCta.localized(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            footnote.localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight.withValues(alpha: 0.7),
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (secondaryAction != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: secondaryAction,
              child: Text('Open email app'.localized(context)),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font16(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle.localized(context),
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.font13(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFB0B0B0)),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: ListTile(
        title: Text(
          title.localized(context),
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
            fontSize: TextSize.font15(context),
          ),
        ),
        trailing: const Icon(Icons.expand_more_rounded),
        onTap: () {},
      ),
    );
  }
}
