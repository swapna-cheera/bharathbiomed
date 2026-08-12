// Drives the app through login -> dashboard -> office-admin-only screens on
// a real device or emulator, capturing Play Store-ready screenshots.
//
// Office Admin access is derived from the signed-in user's Firestore
// Employee.category == 'office_administration' (see
// lib/features/team/team_access.dart), not from Firebase custom claims, so
// any seeded Office Admin test account (e.g. zz_test_oa1, created by
// functions/scripts/seedTestData.ts) works here.
//
// Run with:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/app_screenshot_office_admin_test.dart \
//     -d <deviceId> \
//     --dart-define=TEST_EMAIL=you@example.com \
//     --dart-define=TEST_PASSWORD=yourpassword
//
// Screenshots land in ./screenshots/*.png on the host machine.

import 'package:bharathbiomedpharma/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _testEmail = String.fromEnvironment('TEST_EMAIL');
const _testPassword = String.fromEnvironment('TEST_PASSWORD');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture Office Admin Play Store screenshots', (tester) async {
    expect(
      _testEmail.isNotEmpty && _testPassword.isNotEmpty,
      isTrue,
      reason: 'Pass --dart-define=TEST_EMAIL=... --dart-define=TEST_PASSWORD=... when running this test.',
    );

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    final formFields = find.byType(TextFormField);
    await tester.enterText(formFields.first, _testEmail);
    await tester.enterText(formFields.last, _testPassword);
    await tester.tap(find.text('Sign In & Sync'));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    final okayButton = find.text('Okay');
    if (okayButton.evaluate().isNotEmpty) {
      await tester.tap(okayButton);
      await tester.pumpAndSettle();
    }

    // --- 1. Dashboard home screen (Office Admin sees extra tiles) ---
    await binding.takeScreenshot('oa_01_home');

    // --- 2. Manage Inventory ---
    await tester.ensureVisible(find.text('Manage Inventory'));
    await tester.tap(find.text('Manage Inventory'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('oa_02_inventory');
    await tester.pageBack();
    await tester.pumpAndSettle();

    // --- 3. Partner Requests ---
    await tester.ensureVisible(find.text('Partner Requests'));
    await tester.tap(find.text('Partner Requests'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('oa_03_partner_requests');
  });
}
