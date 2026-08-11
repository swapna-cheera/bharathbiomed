import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_logger.dart';
import '../../core/error/user_facing_error.dart';
import 'sync_controller.dart';

/// Pair of app-bar icons for every dashboard: pull new server data down, and
/// push whatever's queued locally up — the two directions of a sync run
/// independently instead of as one combined action (see
/// [SyncController.pullData]/[SyncController.pushData]). Both surface the
/// same app-wide, full-screen blocking [SyncProgressOverlay] in app.dart
/// while they run, so these buttons don't need their own loading state —
/// they just report the end result in a snackbar.
class SyncAppBarActions extends ConsumerWidget {
  const SyncAppBarActions({super.key});

  Future<void> _run(BuildContext context, WidgetRef ref, Future<void> Function() action, String verb) async {
    debugPrint('SyncAppBarActions._run: $verb requested');
    String resultMessage;
    try {
      await action();
      debugPrint('SyncAppBarActions._run: $verb succeeded');
      resultMessage = '$verb complete.';
    } catch (error, stackTrace) {
      debugPrint('SyncAppBarActions._run: $verb failed error=$error');
      AppLogger.error('SyncAppBarActions', '$verb failed', error: error, stackTrace: stackTrace);
      resultMessage = '$verb failed: ${UserFacingError.describe(error)}';
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMessage)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availability = ref.watch(syncControllerProvider.select((s) => s.availability));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Badge(
            isLabelVisible: availability.remoteHasUpdates,
            child: const Icon(Icons.cloud_download_outlined),
          ),
          tooltip: 'Get data',
          onPressed: () => _run(context, ref, () => ref.read(syncControllerProvider.notifier).pullData(), 'Download'),
        ),
        IconButton(
          icon: Badge(
            label: Text('${availability.pendingUploadCount}'),
            isLabelVisible: availability.pendingUploadCount > 0,
            child: const Icon(Icons.cloud_upload_outlined),
          ),
          tooltip: 'Send data',
          onPressed: () => _run(context, ref, () => ref.read(syncControllerProvider.notifier).pushData(), 'Upload'),
        ),
      ],
    );
  }
}
