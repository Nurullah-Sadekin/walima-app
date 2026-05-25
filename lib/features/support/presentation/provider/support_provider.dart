import 'package:flutter/material.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/support/data/repository/support_repository.dart';
import 'package:walima_llc/features/support/domain/model/contact_support_request.dart';

class SupportProvider extends BaseChangeNotifier {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  bool isSubmitting = false;
  String? errorMessage;
  bool submitted = false;

  bool get canSubmit {
    return !isSubmitting &&
        subjectController.text.trim().isNotEmpty &&
        messageController.text.trim().isNotEmpty;
  }

  Future<bool> submit() async {
    if (isSubmitting) return false;

    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      errorMessage = 'Please fill in subject and message.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    submitted = false;
    notifyListeners();

    final response = await SupportRepository.contactSupport(
      request: ContactSupportRequest(
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subject,
        message: message,
      ),
      isTokenRequired: true,
    );

    isSubmitting = false;
    if (!response.isSuccess) {
      errorMessage = response.message.isNotEmpty
          ? response.message
          : 'Unable to submit. Please try again.';
      notifyListeners();
      return false;
    }

    submitted = true;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
