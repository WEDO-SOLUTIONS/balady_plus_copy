import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading/loading_circular.dart';

/// Size of the loading container
const _loaderSize = 56.0;

/// Size of the loading indicator
const _indicatorSize = 24.0;

const _indicatorStrokeWidth = 2.5;

/// Loading overlay that shows a loading indicator on top of the child widget.
///
/// Provide a child widget and call [makeCall] to make an asynchronous call that will show the loading indicator.
///
/// Example usage:
/// ```dart
/// final result = await LoadingOverlay.of(context).makeCall(() async {
///   // Perform some asynchronous operation here
///   return someResult;
/// });
/// ```
class LoadingOverlay extends StatefulWidget {
  final Widget child;

  const LoadingOverlay({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// Returns the [LoadingOverlayState] of the nearest ancestor [LoadingOverlay] widget.
  static LoadingOverlayState of(BuildContext context) => context.findAncestorStateOfType<LoadingOverlayState>()!;

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

/// The state of the [LoadingOverlay] widget.
class LoadingOverlayState extends State<LoadingOverlay> {
  bool _isLoading = false;

  /// Starts the loading state.
  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  /// Ends the loading state.
  void endLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  /// Makes an asynchronous call and shows the loading indicator while waiting for the result.
  ///
  /// Returns the result of the asynchronous call.
  Future<T> makeCall<T extends Object?>(Future<T> Function() call) async {
    startLoading();
    try {
      final result = await call();
      return result;
    } on Exception catch (_) {
      rethrow;
    } finally {
      endLoading();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          IgnorePointer(
            ignoring: _isLoading,
            child: widget.child,
          ),
          if (_isLoading) ...[
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x33000000),
              ),
            ),
            Align(
              child: Container(
                width: _loaderSize,
                height: _loaderSize,
                padding: const EdgeInsets.all(Spacing.$4x),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const LoadingCircular(
                  size: _indicatorSize,
                  strokeWidth: _indicatorStrokeWidth,
                ),
              ),
            ),
          ],
        ],
      );
}
