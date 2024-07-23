import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// A widget that overlays a toast on top of its child widget.
class ToastOverlay extends StatefulWidget {
  final Widget child;

  /// Creates a [ToastOverlay] widget.
  const ToastOverlay({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// Returns the [ToastOverlayState] of the nearest ancestor [ToastOverlay] widget.
  static ToastOverlayState of(BuildContext context) => context.findAncestorStateOfType<ToastOverlayState>()!;

  @override
  State<ToastOverlay> createState() => ToastOverlayState();
}

class ToastOverlayState extends State<ToastOverlay> {
  OverlayEntry? _overlayEntry;

  /// Displays a toast overlay with the specified [title], [actionText], and [onActionTap] callback.
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
    required String actionText,
    required VoidCallback onActionTap,
    String? iconAsset,
    IconData? iconData,
    Duration displayDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      canSizeOverlay: true,
      builder: (_) => Positioned(
        left: Spacing.$2x,
        right: Spacing.$2x,
        top: Spacing.$2x,
        child: Theme(
          data: Theme.of(context),
          child: SafeArea(
            child: _ToastTransition(
              hide: hide,
              title: title,
              actionText: actionText,
              onActionTap: onActionTap,
              iconAsset: iconAsset,
              displayDuration: displayDuration,
              transitionDuration: transitionDuration,
              iconData: iconData,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Displays a base error toast overlay.
  ///
  /// The [onRetry] callback is invoked when the user taps on the action button
  ///
  /// [title] is set to 'Failed to load data'.
  /// [actionText] is set to 'Try again'.
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
      actionText: context.l10n.tryAgain,
      onActionTap: onRetry,
      iconData: SystemIcons.noServer,
    );
  }

  /// Displays a toast notification indicating that there is no internet connection.
  ///
  /// The [onRetry] callback is invoked when the user taps on the action button
  ///
  /// [title] is set to 'You don't seem to have internet'.
  /// [actionText] is set to 'Try again'.
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
      actionText: context.l10n.tryAgain,
      onActionTap: onRetry,
      iconData: SystemIcons.offline,
    );
  }

  /// Hides the toast overlay by removing the [_overlayEntry].
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _ToastTransition extends StatefulWidget {
  final String title;
  final String actionText;
  final VoidCallback hide;
  final VoidCallback onActionTap;
  final String? iconAsset;
  final IconData? iconData;
  final Duration displayDuration;
  final Duration transitionDuration;

  const _ToastTransition({
    required this.hide,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.iconAsset,
    required this.iconData,
    required this.transitionDuration,
    required this.displayDuration,
  });

  @override
  State<_ToastTransition> createState() => __ToastTransitionState();
}

class __ToastTransitionState extends State<_ToastTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();

    Future.delayed(widget.displayDuration, _hide);
  }

  Future<void> _hide() async {
    await _controller.reverse();
    if (_controller.isCompleted) {
      widget.hide();
    }
  }

  void _onActionTap() {
    _hide();
    widget.onActionTap();
  }

  @override
  Widget build(BuildContext context) => Dismissible(
        key: UniqueKey(),
        onDismissed: (_) => _hide(),
        direction: DismissDirection.up,
        child: SlideTransition(
          position: _animation,
          child: _ToastWidget(
            title: widget.title,
            actionText: widget.actionText,
            onActionTap: _onActionTap,
            iconAsset: widget.iconAsset,
            iconData: widget.iconData,
          ),
        ),
      );
}

class _ToastWidget extends StatelessWidget {
  final String title;
  final String actionText;
  final String? iconAsset;
  final IconData? iconData;

  final VoidCallback onActionTap;

  const _ToastWidget({
    required this.title,
    required this.actionText,
    required this.onActionTap,
    this.iconData,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          left: Spacing.$4x,
          right: Spacing.$4x,
          top: Spacing.$3x,
        ),
        decoration: BoxDecoration(
          color: context.colorsV2.backgroundSurface1,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 56,
              offset: Offset(18, 0),
            ),
            BoxShadow(
              color: Color(0x0B000000),
              blurRadius: 20,
              offset: Offset(18, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textStyleV3.bodyLargeRegular,
                  ),
                  GestureDetector(
                    onTap: onActionTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                      child: Text(
                        actionText,
                        style: context.textStyleV3.bodyLargeRegular.copyWith(
                          color: context.colorsV2.accentActive,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            if (iconData != null)
              Icon(
                iconData,
                color: context.colorsV2.foregroundDefault,
              )
            else if (iconAsset != null)
              SvgPicture.asset(iconAsset!),
          ],
        ),
      );
}
