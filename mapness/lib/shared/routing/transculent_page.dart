import 'package:flutter/material.dart';

class TranslucentRoute<T> extends TransitionRoute<T> {
  final bool _opaque;
  final Duration _transitionDuration;
  final RouteTransitionsBuilder _transitionBuilder;
  final RoutePageBuilder _pageBuilder;

  TranslucentRoute({
    opaque = true,
    transitionDuration = const Duration(milliseconds: 300),
    required RouteTransitionsBuilder transitionBuilder,
    required RoutePageBuilder pageBuilder,
    RouteSettings? settings,
  })  : _opaque = opaque,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        _pageBuilder = pageBuilder,
        super(settings: settings);

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        builder: (context) => _transitionBuilder(
          context,
          animation!,
          secondaryAnimation!,
          _pageBuilder(
            context,
            animation!,
            secondaryAnimation!,
          ),
        ),
      ),
    ];
  }

  @override
  bool get opaque => _opaque;

  @override
  Duration get transitionDuration => _transitionDuration;
}

class TransculentTransitionPage<T> extends Page<T> {
  final bool _opaque;
  final Duration _transitionDuration;
  final RouteTransitionsBuilder _transitionBuilder;
  final Widget _child;

  const TransculentTransitionPage({
    opaque = true,
    transitionDuration = const Duration(milliseconds: 300),
    required RouteTransitionsBuilder transitionBuilder,
    required Widget child,
  })  : _opaque = opaque,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        _child = child;

  @override
  Route<T> createRoute(BuildContext context) {
    return TranslucentRoute<T>(
      opaque: _opaque,
      transitionBuilder: _transitionBuilder,
      transitionDuration: _transitionDuration,
      pageBuilder: (_, __, ___) => _child,
      settings: this,
    );
  }
}
