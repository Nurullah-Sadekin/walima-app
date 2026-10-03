import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';

void main() {
  testWidgets('error dialog OK button dismisses the dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              DialogUtils.showErrorDialog(
                context: context,
                message: 'Invalid phone number.',
                buttonText: 'OK',
              );
            },
            child: const Text('Show error'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show error'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('error dialog close button dismisses the dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              DialogUtils.showErrorDialog(
                context: context,
                message: 'Invalid phone number.',
                buttonText: 'OK',
              );
            },
            child: const Text('Show error'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show error'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('hidden close button is not rendered', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              DialogUtils.showErrorDialog(
                context: context,
                message: 'Account already exists.',
                buttonText: 'Go to Login',
                hideCloseButton: true,
              );
            },
            child: const Text('Show error'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show error'));
    await tester.pumpAndSettle();

    expect(find.text('Go to Login'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}
