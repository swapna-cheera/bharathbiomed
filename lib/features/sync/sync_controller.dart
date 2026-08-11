import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_logger.dart';
import '../../data/providers.dart';
import '../admin/admin_access.dart';
import '../auth/auth_controller.dart';
import '../catalog/catalog_controller.dart';

/// Step-by-step progress for an in-flight sync, so the UI can show a
/// percentage instead of a bare spinner while the user is asked to keep the
/// app open.
class SyncProgress {
  const SyncProgress({required this.completed, required this.total, required this.label});

  final int completed;
  final int total;
  final String label;

  double get fraction => total == 0 ? 0 : completed / total;
}

/// Whether there's anything worth syncing: new/changed data on the server,
/// or data queued locally (usage sessions, doctor requests, visit logs/plan)
/// that hasn't reached Firestore yet.
class SyncAvailability {
  const SyncAvailability({required this.remoteHasUpdates, required this.pendingUploadCount});

  static const none = SyncAvailability(remoteHasUpdates: false, pendingUploadCount: 0);

  final bool remoteHasUpdates;
  final int pendingUploadCount;
}

class SyncState {
  const SyncState({this.availability = SyncAvailability.none, this.progress});

  final SyncAvailability availability;
  final SyncProgress? progress;

  bool get isSyncing => progress != null;
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(SyncController.new);

/// Surfaces "is there anything new to sync" as a UI prompt (a banner the
/// user taps — see `sync_overlay.dart`) instead of syncing silently, and
/// reports step progress while a sync runs so the UI can show a percentage
/// and warn against closing the app mid-sync. See `app.dart` for what
/// triggers [checkForUpdates] (connectivity restored, app resumed while
/// online, auth resolving to a signed-in user).
class SyncController extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState();

  /// Fetches remote data to diff against the local cache (see
  /// [ProductRepository.hasRemoteChanges]) and counts anything queued
  /// locally. Best-effort: a failed check leaves availability exactly as it
  /// was, so it neither hides a previously-known pending sync nor fabricates
  /// a new one.
  Future<void> checkForUpdates() async {
    if (ref.read(authControllerProvider).value == null) return;
    debugPrint('SyncController.checkForUpdates: checking for remote changes and pending uploads');
    try {
      final isAdmin = ref.read(isAdminProvider);
      final mrUid = isAdmin ? null : ref.read(authControllerProvider).value?.uid;

      final remoteChanged = await Future.wait<bool>([
        ref.read(productRepositoryProvider).hasRemoteChanges(),
        ref.read(doctorRepositoryProvider).hasRemoteChanges(mrUid: mrUid),
        ref.read(agencyRepositoryProvider).hasRemoteChanges(),
        ref.read(pharmacyRepositoryProvider).hasRemoteChanges(),
      ]);
      final pendingCounts = await Future.wait<int>([
        ref.read(usageSessionRepositoryProvider).countPendingUpload(),
        ref.read(doctorChangeRequestRepositoryProvider).countPendingUpload(),
        ref.read(doctorVisitLogRepositoryProvider).countPendingUpload(),
        ref.read(entityChangeRequestRepositoryProvider).countPendingUpload(),
        ref.read(orderRepositoryProvider).countPendingUpload(),
        ref.read(rcpaRepositoryProvider).countPendingUpload(),
        ref.read(expenseClaimRepositoryProvider).countPendingUpload(),
        ref.read(complianceLogRepositoryProvider).countPendingUpload(),
        if (mrUid != null)
          ref.read(doctorVisitPlanRepositoryProvider).hasPendingUpload(mrUid).then((has) => has ? 1 : 0),
      ]);

      final remoteHasUpdates = remoteChanged.contains(true);
      final pendingUploadCount = pendingCounts.fold<int>(0, (sum, count) => sum + count);

      state = SyncState(
        availability: SyncAvailability(remoteHasUpdates: remoteHasUpdates, pendingUploadCount: pendingUploadCount),
        progress: state.progress,
      );
      debugPrint(
          'SyncController.checkForUpdates: remoteHasUpdates=$remoteHasUpdates pendingUploadCount=$pendingUploadCount');
    } catch (error, stackTrace) {
      debugPrint('SyncController.checkForUpdates: failed error=$error');
      AppLogger.error('SyncController', 'checkForUpdates failed', error: error, stackTrace: stackTrace);
    }
  }

  /// Runs [CatalogController.sync], reporting [SyncProgress] as it goes, and
  /// clears [SyncAvailability] to none on success (the sync just pulled and
  /// pushed everything the check above found).
  Future<void> startSync() async {
    if (state.isSyncing) return;
    debugPrint('SyncController.startSync: starting sync');
    state = SyncState(
      availability: state.availability,
      progress: const SyncProgress(completed: 0, total: 1, label: 'Starting sync…'),
    );
    try {
      await ref.read(catalogControllerProvider.notifier).sync(
        onProgress: (completed, total, label) {
          state = SyncState(
            availability: state.availability,
            progress: SyncProgress(completed: completed, total: total, label: label),
          );
        },
      );
      debugPrint('SyncController.startSync: sync succeeded');
      state = const SyncState();
    } catch (error, stackTrace) {
      debugPrint('SyncController.startSync: sync failed error=$error');
      AppLogger.error('SyncController', 'startSync failed', error: error, stackTrace: stackTrace);
      state = SyncState(availability: state.availability);
      rethrow;
    }
  }

  /// "Get data" half of a sync, run independently of [pushData] — see the
  /// app-bar download action in `sync_app_bar_actions.dart`. Only clears the
  /// remote-updates half of [SyncAvailability] on success; a still-pending
  /// upload count is left exactly as it was.
  Future<void> pullData() async {
    if (state.isSyncing) return;
    debugPrint('SyncController.pullData: starting pull');
    state = SyncState(
      availability: state.availability,
      progress: const SyncProgress(completed: 0, total: 1, label: 'Starting download…'),
    );
    try {
      await ref.read(catalogControllerProvider.notifier).pull(
        onProgress: (completed, total, label) {
          state = SyncState(
            availability: state.availability,
            progress: SyncProgress(completed: completed, total: total, label: label),
          );
        },
      );
      debugPrint('SyncController.pullData: pull succeeded');
      state = SyncState(
        availability: SyncAvailability(remoteHasUpdates: false, pendingUploadCount: state.availability.pendingUploadCount),
      );
    } catch (error, stackTrace) {
      debugPrint('SyncController.pullData: pull failed error=$error');
      AppLogger.error('SyncController', 'pullData failed', error: error, stackTrace: stackTrace);
      state = SyncState(availability: state.availability);
      rethrow;
    }
  }

  /// "Send data" half of a sync, run independently of [pullData] — see the
  /// app-bar upload action in `sync_app_bar_actions.dart`. Only clears the
  /// pending-upload half of [SyncAvailability] on success; a known remote
  /// update is left exactly as it was.
  Future<void> pushData() async {
    if (state.isSyncing) return;
    debugPrint('SyncController.pushData: starting push');
    state = SyncState(
      availability: state.availability,
      progress: const SyncProgress(completed: 0, total: 1, label: 'Starting upload…'),
    );
    try {
      await ref.read(catalogControllerProvider.notifier).push(
        onProgress: (completed, total, label) {
          state = SyncState(
            availability: state.availability,
            progress: SyncProgress(completed: completed, total: total, label: label),
          );
        },
      );
      debugPrint('SyncController.pushData: push succeeded');
      state = SyncState(
        availability: SyncAvailability(remoteHasUpdates: state.availability.remoteHasUpdates, pendingUploadCount: 0),
      );
    } catch (error, stackTrace) {
      debugPrint('SyncController.pushData: push failed error=$error');
      AppLogger.error('SyncController', 'pushData failed', error: error, stackTrace: stackTrace);
      state = SyncState(availability: state.availability);
      rethrow;
    }
  }
}
