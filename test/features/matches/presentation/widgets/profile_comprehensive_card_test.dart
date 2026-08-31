import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/matches/presentation/widgets/profile_comprehensive_card.dart';

void main() {
  testWidgets('locked visitor card does not expose identity or actions',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileComprehensiveCard(
            imagePath: 'unused-while-locked',
            imageHeight: 200,
            name: 'Private Visitor Name',
            age: '31 Yr',
            location: 'Private Location',
            isLocked: true,
          ),
        ),
      ),
    );

    expect(find.text('Upgrade to view this visitor'), findsOneWidget);
    expect(find.text('Private Visitor Name'), findsNothing);
    expect(find.text('Private Location'), findsNothing);
    expect(find.text('Connect'), findsNothing);
    expect(find.text('Contact'), findsNothing);
  });
}
