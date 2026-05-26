import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/support/presentation/provider/ai_support_provider.dart';

class AiSupportChatScreen extends ConsumerWidget {
  const AiSupportChatScreen({super.key});

  static const String _email = 'support@walima.app';
  static const String _phoneBd = '+8801305455665';
  static const String _phoneUs = '+13072129537';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(aiSupportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Stack(
        children: [
          Column(
            children: [
              CustomBackAppBar(
                title: Text('AI Support'.localized(context)),
                onBackPressed: () => context.pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'Get fast, account-aware support for plans, payments, verification, and match issues. Escalate to a human whenever you need.'
                          .localized(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                        fontSize: TextSize.font14(context),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HeaderCard(
                      isActive: true,
                      onTalkToHuman: provider.isLoading
                          ? null
                          : () => ref.read(aiSupportProvider).escalateToHuman(),
                    ),
                    const SizedBox(height: 16),
                    if (provider.errorMessage != null) ...[
                      _InlineError(message: provider.errorMessage!),
                      const SizedBox(height: 12),
                    ],
                    _ChatArea(
                      messages: provider.messages,
                      isThinking: provider.isThinking,
                    ),
                    const SizedBox(height: 16),
                    _Composer(
                      controller: provider.messageController,
                      canSend: provider.canSend && !provider.isThinking,
                      onSend: provider.isLoading || provider.isThinking
                          ? null
                          : () => ref.read(aiSupportProvider).sendMessage(),
                    ),
                    const SizedBox(height: 22),
                    _SupportStatus(ticketId: provider.ticketId),
                    const SizedBox(height: 14),
                    _ContactCard(
                      icon: Icons.mail_outline_rounded,
                      title: 'Email',
                      subtitle: _email,
                      onTap: () => _sendEmail(_email),
                    ),
                    const SizedBox(height: 10),
                    _ContactCard(
                      icon: Icons.call_outlined,
                      title: 'Phone',
                      subtitle: '$_phoneBd, $_phoneUs',
                      onTap: () => _callNumber(_phoneBd),
                    ),
                    const SizedBox(height: 18),
                    const _TicketsCard(ticketCount: 0),
                  ],
                ),
              ),
            ],
          ),
          if (provider.isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.08),
              child: const Center(child: Loading()),
            ),
        ],
      ),
    );
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.isActive,
    required this.onTalkToHuman,
  });

  final bool isActive;
  final VoidCallback? onTalkToHuman;

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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Live Support Bot'.localized(context),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF7EA),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  (isActive ? 'active' : 'inactive').localized(context),
                  style: TextStyle(
                    color: const Color(0xFF18794E),
                    fontWeight: FontWeight.w800,
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Chat with Walima support'.localized(context),
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w900,
              fontSize: TextSize.font22(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ask about account issues, payments, verification, or match-related support.'
                .localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
              fontSize: TextSize.font14(context),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onTalkToHuman,
            icon: const Icon(Icons.support_agent_outlined),
            label: Text('Talk to a human'.localized(context)),
          ),
        ],
      ),
    );
  }
}

class _ChatArea extends StatelessWidget {
  const _ChatArea({required this.messages, required this.isThinking});

  final List<AiSupportMessage> messages;
  final bool isThinking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD9E2F2)),
            ),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEF2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Start with a short description of your issue'
                      .localized(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w900,
                    fontSize: TextSize.font18(context),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Examples: "Why did my payment fail?", "What is my verification status?", or "I need help with a match conversation."'
                      .localized(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: TextSize.font13(context),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...messages.map((m) => _MessageBubble(message: m)),
          if (isThinking)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: _ThinkingBubble(),
            ),
        ],
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          'AI is thinking...'.localized(context),
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final AiSupportMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiSupportRole.user;
    final bg = isUser ? const Color(0xFFFFEEF2) : const Color(0xFFF2F6FF);
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              message.text.localized(context),
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w500,
                fontSize: TextSize.font13(context),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool canSend;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: 4,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Type your question here...'.localized(context),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6ECE9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6ECE9)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Use Shift+Enter for a new line. Your chat is stored with a ticket reference when human support is needed.'
              .localized(context),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: canSend ? onSend : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Send message'.localized(context),
              style: TextStyle(
                fontSize: TextSize.font16(context),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportStatus extends StatelessWidget {
  const _SupportStatus({required this.ticketId});

  final String? ticketId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support status'.localized(context),
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w900,
              fontSize: TextSize.font20(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Recent ticket activity and direct contact options.'
                .localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
              fontSize: TextSize.font13(context),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6ECE9)),
            ),
            child: Text(
              ticketId == null
                  ? 'No ticket created in this session yet. The bot can open one when needed.'
                      .localized(context)
                  : 'Ticket reference: $ticketId'.localized(context),
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
                fontSize: TextSize.font13(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.localized(context),
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
                fontSize: TextSize.font13(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
                      fontWeight: FontWeight.w900,
                      fontSize: TextSize.font16(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: TextSize.font13(context),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded, color: Color(0xFFB0B0B0)),
          ],
        ),
      ),
    );
  }
}

class _TicketsCard extends StatelessWidget {
  const _TicketsCard({required this.ticketCount});

  final int ticketCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0D6DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My support tickets'.localized(context),
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w900,
                        fontSize: TextSize.font20(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your latest requests, escalations, and ticket references.'
                          .localized(context),
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                        fontSize: TextSize.font13(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$ticketCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: TextSize.font14(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD9E2F2)),
            ),
            child: Center(
              child: Text(
                'No support tickets yet.'.localized(context),
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: TextSize.font14(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
