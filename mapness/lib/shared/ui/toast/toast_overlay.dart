import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/app_locale.dart';
import 'package:mapness/shared/utils/detach.dart';

part 'toast_transition.dart';
part 'toast_widget.dart';
part 'models/toast_action.dart';
part 'models/toast_icon.dart';

/// A widget that overlays a toast on top of its child widget.
class ToastOverlay extends StatefulWidget {
  final Widget child;

  /// Creates a [ToastOverlay] widget.
  const ToastOverlay({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// Returns the [ToastOverlayState] of the nearest ancestor [ToastOverlay] widget.
  static ToastOverlayState of(BuildContext context) {
    final toastOverlay = context.findAncestorStateOfType<ToastOverlayState>();
    assert(toastOverlay != null, 'No ToastOverlay found in context');
    return toastOverlay!;
  }

  @override
  State<ToastOverlay> createState() => ToastOverlayState();
}

class ToastOverlayState extends State<ToastOverlay> {
  static const _betaNotificationTitleKey = 'beta_notification';
  static const defaultDisplayDuration = Duration(seconds: 2);
  static const actionableDisplayDuration = Duration(seconds: 10);

  OverlayEntry? _overlayEntry;

  /// Displays a toast overlay with the specified [title], [firstText], and [onFirstTap] callback.
  /// If toast is already showing, it will be replaced with the new toast.
  ///
  ///
  /// The [iconAsset] and [iconData] parameters can be used to specify an icon for the toast.
  /// If both [iconAsset] and [iconData] are provided, [iconData] will be used.
  ///
  /// The [displayDuration] parameter determines how long the toast will be displayed on the screen.
  /// The [transitionDuration] parameter determines the duration of the transition animation.
  ///
  /// Example usage:
  /// ```dart
  /// ToastOverlay.of(context).show(
  ///   title: 'Hello',
  ///   actionText: 'Dismiss',
  ///   onActionTap: () {
  ///     // Handle action tap
  ///   },
  /// );
  /// ```

  void show({
    required String title,
    TextStyle? titleStyle,
    List<ToastAction>? actions,
    ToastIcon? icon,
    bool? isDismissible,
    bool isClosable = false,
    bool isFlipped = false,
    Duration displayDuration = defaultDisplayDuration,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    hide();

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      canSizeOverlay: true,
      builder: (_) => ProviderScope(
        child: Positioned(
          left: Spacing.$2x,
          right: Spacing.$2x,
          top: Spacing.$2x,
          child: Theme(
            data: Theme.of(context),
            child: _ToastTransition(
              isDismissible: isDismissible,
              isClosable: isClosable,
              isFlipped: isFlipped,
              hide: () => _removeEntry(overlayEntry),
              title: title,
              titleStyle: titleStyle,
              actions: actions,
              displayDuration: displayDuration,
              transitionDuration: transitionDuration,
              icon: icon,
            ),
          ),
        ),
      ),
    );

    _overlayEntry = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
  }

  /// Displays a base error toast overlay.
  ///
  /// The [onRetry] callback is invoked when the user taps on the action button
  ///
  /// [title] is set to 'Failed to load data'.
  /// [firstText] is set to 'Try again'.
  /// [iconData] is set to [SystemIcons.noServer].
  ///
  /// Example usage:
  /// ```dart
  /// ToastOverlay.of(context).show(
  ///   onRetry: () {
  ///     // Retry logic here
  ///   },
  /// );
  /// ```
  void showBaseError({
    required VoidCallback onRetry,
  }) {
    show(
      title: context.l10n.failedToLoadData,
      actions: [
        ToastAction(
          title: context.l10n.tryAgain,
          onTap: onRetry,
        ),
      ],
      icon: const ToastIconData(SystemIcons.noServer),
      displayDuration: actionableDisplayDuration,
    );
  }

  /// Displays a toast notification indicating that there is no internet connection.
  ///
  /// The [onRetry] callback is invoked when the user taps on the action button
  ///
  /// [title] is set to 'You don't seem to have internet'.
  /// [firstText] is set to 'Try again'.
  /// [iconData] is set to [SystemIcons.offline].
  ///
  /// Example usage:
  /// ```dart
  /// ToastOverlay.of(context).showNoInternet(
  ///  onRetry: () {
  ///   // Retry logic here
  /// },
  /// );
  /// ```
  void showNoInternet({
    required VoidCallback onRetry,
  }) {
    show(
      title: context.l10n.youDontSeemToHaveInternet,
      actions: [
        ToastAction(
          title: context.l10n.tryAgain,
          onTap: onRetry,
        ),
      ],
      icon: const ToastIconData(SystemIcons.offline),
      displayDuration: actionableDisplayDuration,
    );
  }

  /// Displays a toast notification only when it is the first time user opens the app.
  ///
  /// [title] is set to 'beta_notification' to resolve it with localization later.
  /// [iconData] is set to [General16Icons.infoCircleFill].
  /// [isDismissible] is set to `true`.
  /// [isClosable] is set to `true`.
  /// [isFlipped] is set to `true`.
  /// [displayDuration] is set to `20 seconds`.
  ///
  /// Example usage:
  /// ```dart
  /// ToastOverlay.of(context).showBetaNotification();
  /// ```
  void showBetaNotification() {
    show(
      title: _betaNotificationTitleKey,
      titleStyle: context.textStyles.captionLargeRegular.copyWith(fontSize: context.isLTR ? 12 : 13),
      isDismissible: true,
      isClosable: true,
      isFlipped: true,
      icon: ToastIconData(
        General16Icons.infoCircleFill,
        color: context.colors.accentDefault,
      ),
      displayDuration: const Duration(seconds: 20),
    );
  }

  /// Hides the toast overlay by removing the [_overlayEntry].
  void hide() {
    final overlayEntry = _overlayEntry;
    if (overlayEntry != null) {
      _removeEntry(overlayEntry);
    }
  }

  void _removeEntry(OverlayEntry overlayEntry) {
    if (_overlayEntry == overlayEntry) {
      _overlayEntry = null;
    }

    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
