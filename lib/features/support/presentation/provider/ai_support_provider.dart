import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/support/support_bot/data/repository/support_bot_repository.dart';
import 'package:walima_llc/features/support/support_bot/data/socket/support_bot_socket_service.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_done_event.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_message.dart';

class AiSupportProvider extends BaseChangeNotifier {
  AiSupportProvider() {
    messageController.addListener(_onChanged);
    _initialize();
  }

  final messageController = TextEditingController();
  final List<AiSupportMessage> messages = <AiSupportMessage>[];

  bool isEscalatedToHuman = false;
  String? ticketId;
  String? conversationId;
  bool isLoading = true;
  bool isThinking = false;
  String? errorMessage;

  String? _pendingJobId;
  StreamSubscription<SupportBotDoneEvent>? _doneSub;
  StreamSubscription<Map<String, dynamic>>? _errorSub;

  bool get canSend => messageController.text.trim().isNotEmpty;

  void _onChanged() => notifyListeners();

  Future<void> _initialize() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final convoResponse =
        await SupportBotRepository.createOrResumeConversation();
    if (!convoResponse.isSuccess || convoResponse.data == null) {
      isLoading = false;
      errorMessage = convoResponse.message.isNotEmpty
          ? convoResponse.message
          : 'Unable to start support chat.';
      notifyListeners();
      return;
    }

    conversationId = convoResponse.data!.id;

    final historyResponse = await SupportBotRepository.getMessages(
      conversationId: conversationId!,
      page: 1,
      size: 50,
    );

    messages.clear();
    if (historyResponse.isSuccess && historyResponse.data != null) {
      for (final msg in historyResponse.data!) {
        messages.add(_toUiMessage(msg));
      }
    }

    if (messages.isEmpty) {
      messages.add(
        const AiSupportMessage(
          role: AiSupportRole.bot,
          text:
              'Hi! Tell me a bit about your issue and I’ll help you. If you want, you can also escalate to a human.',
        ),
      );
    }

    await SupportBotSocketService.instance.connect();
    SupportBotSocketService.instance.joinConversation(conversationId!);

    _doneSub?.cancel();
    _errorSub?.cancel();
    _doneSub = SupportBotSocketService.instance.done.listen(_handleDone);
    _errorSub = SupportBotSocketService.instance.errors.listen((payload) {
      errorMessage = (payload['message'] ?? 'Something went wrong.').toString();
      isThinking = false;
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }

  AiSupportMessage _toUiMessage(SupportBotMessage msg) {
    final role = msg.role.toLowerCase();
    final isUser = role == 'user' || role == 'customer';
    return AiSupportMessage(
      role: isUser ? AiSupportRole.user : AiSupportRole.bot,
      text: msg.content,
    );
  }

  Future<void> escalateToHuman() async {
    if (isEscalatedToHuman) return;
    final cid = conversationId;
    if (cid == null || cid.isEmpty) return;

    final response = await SupportBotRepository.escalate(conversationId: cid);
    if (!response.isSuccess) {
      errorMessage = response.message.isNotEmpty
          ? response.message
          : 'Unable to escalate right now.';
      notifyListeners();
      return;
    }

    final data = response.data ?? const <String, dynamic>{};
    isEscalatedToHuman = data['escalated'] == true || isEscalatedToHuman;
    ticketId = data['ticketId']?.toString() ?? ticketId;

    if (isEscalatedToHuman) {
      messages.add(
        AiSupportMessage(
          role: AiSupportRole.bot,
          text: ticketId == null || ticketId!.isEmpty
              ? 'Got it — I’ve escalated this to a human support agent.'
              : 'Got it — I’ve created a ticket ($ticketId). A human support agent will follow up soon.',
        ),
      );
    }
    notifyListeners();
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final cid = conversationId;
    if (cid == null || cid.isEmpty) {
      errorMessage = 'Support chat is not ready yet.';
      notifyListeners();
      return;
    }

    messages.add(AiSupportMessage(role: AiSupportRole.user, text: text));
    messageController.clear();

    isThinking = true;
    errorMessage = null;
    notifyListeners();

    final queuedResponse = await SupportBotRepository.sendMessage(
      conversationId: cid,
      content: text,
    );

    if (!queuedResponse.isSuccess || queuedResponse.data == null) {
      isThinking = false;
      errorMessage = queuedResponse.message.isNotEmpty
          ? queuedResponse.message
          : 'Failed to send message.';
      notifyListeners();
      return;
    }

    _pendingJobId = queuedResponse.data!.jobId;
    SupportBotSocketService.instance.send(conversationId: cid, content: text);
    notifyListeners();
  }

  void _handleDone(SupportBotDoneEvent event) {
    final cid = conversationId;
    if (cid == null || cid.isEmpty) return;
    if (event.conversationId.isNotEmpty && event.conversationId != cid) return;
    if (_pendingJobId != null &&
        _pendingJobId!.isNotEmpty &&
        event.jobId.isNotEmpty &&
        event.jobId != _pendingJobId) {
      return;
    }

    isThinking = false;
    _pendingJobId = null;

    if (event.finalText.trim().isNotEmpty) {
      messages.add(
        AiSupportMessage(role: AiSupportRole.bot, text: event.finalText),
      );
    }

    if (event.escalated) {
      isEscalatedToHuman = true;
      ticketId = event.ticketId ?? ticketId;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.removeListener(_onChanged);
    messageController.dispose();
    _doneSub?.cancel();
    _errorSub?.cancel();
    super.dispose();
  }
}

enum AiSupportRole { user, bot }

class AiSupportMessage {
  const AiSupportMessage({required this.role, required this.text});
  final AiSupportRole role;
  final String text;
}
