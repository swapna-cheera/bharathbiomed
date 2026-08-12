// Drives the app through login -> dashboard -> "My Team" manager screens on
// a real device or emulator, capturing Play Store-ready screenshots.
//
// Any employee can open '/team' (see lib/features/team/team_home_screen.dart)
// — the screens behind it are only meaningful for someone with a downline
// (Employee.reportingChainUids) and manager permissions (approve_orders,
// approve_requests, etc.), so this is meant to run against a seeded manager
// account (e.g. zz_test_abm1, created by functions/scripts/seedTestData.ts),
// which has real MR reports with seeded orders/visits/RCPA data underneath.
//
// Run with:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/app_screenshot_manager_test.dart \
//     -d <deviceId> \
//     --dart-define=TEST_EMAIL=you@example.com \
//     --dart-define=TEST_PASSWORD=yourpassword
//
// Screenshots land in ./screenshots/*.png on the host machine.

import 'package:bharathbiomedpharma/features/team/team_home_screen.dart';
import 'package:bharathbiomedpharma/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _testEmail = String.fromEnvironment('TEST_EMAIL');
const _testPassword = String.fromEnvironment('TEST_PASSWORD');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture Manager Play Store screenshots', (tester) async {
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

    // --- 1. My Team ---
    await tester.ensureVisible(find.text('My Team'));
    await tester.tap(find.text('My Team'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('mgr_01_team_home');

    // Dashboard stays mounted (just obscured) underneath this pushed route,
    // so any tile label it shares with Dashboard (e.g. 'RCPA Entries') would
    // otherwise match twice — scope every lookup below to TeamHomeScreen.
    final teamHome = find.byType(TeamHomeScreen);

    // --- 2. Order Workflow ---
    final orderWorkflow = find.descendant(of: teamHome, matching: find.text('Order Workflow'));
    if (orderWorkflow.evaluate().isNotEmpty) {
      await tester.ensureVisible(orderWorkflow);
      await tester.tap(orderWorkflow);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('mgr_02_order_workflow');
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // --- 3. Visit Plan Approvals ---
    final visitApprovals = find.descendant(of: teamHome, matching: find.text('Visit Plan Approvals'));
    if (visitApprovals.evaluate().isNotEmpty) {
      await tester.ensureVisible(visitApprovals);
      await tester.tap(visitApprovals);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('mgr_03_visit_plan_approvals');
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // --- 4. RCPA dashboard ---
    final rcpa = find.descendant(of: teamHome, matching: find.text('RCPA Entries'));
    if (rcpa.evaluate().isNotEmpty) {
      await tester.ensureVisible(rcpa);
      await tester.tap(rcpa);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('mgr_04_rcpa_dashboard');
    }
  });
}
