import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/global/components/resend_code_timer.dart';

void main() {
  testWidgets('uses a 30 second default resend countdown', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendCodeTimer(onResend: () async {}),
        ),
      ),
    );

    expect(find.text('Resend Code in 0:30'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend Code in 0:29'), findsOneWidget);
  });
}
