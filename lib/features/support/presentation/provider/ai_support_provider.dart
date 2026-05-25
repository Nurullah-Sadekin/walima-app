import 'package:flutter/material.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';

class AiSupportProvider extends BaseChangeNotifier {
  AiSupportProvider() {
    messageController.addListener(_onChanged);
  }

  final messageController = TextEditingController();
  final List<AiSupportMessage> messages = <AiSupportMessage>[
    const AiSupportMessage(
      role: AiSupportRole.bot,
      text:
          'Hi! Tell me a bit about your issue and I’ll help you. If you want, you can also escalate to a human.',
    ),
  ];

  bool isEscalatedToHuman = false;
  String? ticketReference;

  bool get canSend => messageController.text.trim().isNotEmpty;

  void _onChanged() => notifyListeners();

  void escalateToHuman() {
    if (isEscalatedToHuman) return;
    isEscalatedToHuman = true;
    ticketReference ??= 'WAL-${DateTime.now().millisecondsSinceEpoch}';
    messages.add(
      AiSupportMessage(
        role: AiSupportRole.bot,
        text:
            'Got it — I’ve created a ticket (${ticketReference!}). A human support agent will follow up soon.',
      ),
    );
    notifyListeners();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add(AiSupportMessage(role: AiSupportRole.user, text: text));
    messageController.clear();

    // Placeholder “bot” response until backend chat is wired.
    messages.add(
      const AiSupportMessage(
        role: AiSupportRole.bot,
        text:
            'Thanks — I’m looking into that. If this needs a human, tap “Talk to a human”.',
      ),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.removeListener(_onChanged);
    messageController.dispose();
    super.dispose();
  }
}

enum AiSupportRole { user, bot }

class AiSupportMessage {
  const AiSupportMessage({required this.role, required this.text});
  final AiSupportRole role;
  final String text;
}
