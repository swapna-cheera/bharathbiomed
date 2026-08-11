import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_controller.dart';
import 'connectivity_provider.dart';

/// Slim, non-interactive top banner shown app-wide (once signed in — the
/// login screen already has its own connectivity status pill, see
/// `login_screen.dart`) whenever the device has no network connectivity, so
/// a field rep working in a low-signal clinic knows why sync/notifications
/// aren't happening instead of assuming the app is broken. Purely
/// informational: no tap action, and it disappears the instant connectivity
/// returns.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(authControllerProvider).value != null;
    final connectivity = ref.watch(connectivityProvider).value;
    final isOffline = signedIn && connectivity != null && NetworkStatus.isOffline(connectivity);
    if (!isOffline) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Material(
        color: scheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, color: scheme.onErrorContainer, size: 16),
              const SizedBox(width: 8),
              Text(
                "Offline — you're working from your last synced data",
                style: TextStyle(color: scheme.onErrorContainer, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
