import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:sheetify/sheetify.dart';
import 'package:shimmer/shimmer.dart';

/// Unified event logo widget that displays event-specific logos with animations
class CityEventLogo extends StatefulWidget {
  final EventLogoConfig config;
  final VoidCallback? onTap;
  final AnimationController? fireworksController;

  const CityEventLogo({required this.config, super.key, this.onTap, this.fireworksController});

  @override
  State<CityEventLogo> createState() => _CityEventLogoState();
}

class _CityEventLogoState extends State<CityEventLogo> with SingleTickerProviderStateMixin {
  bool _showShimmer = false;
  Timer? _timer;

  late final AnimationController scaleController = AnimationController(vsync: this, duration: Durations.medium1);

  @override
  void initState() {
    super.initState();
    if (widget.config.hasShimmer) {
      _startShimmerTimer();
    }
  }

  void _startShimmerTimer() {
    _timer = Timer.periodic(widget.config.shimmerInterval, (_) {
      if (mounted) {
        setState(() => _showShimmer = true);
        Future.delayed(widget.config.shimmerPeriod, () {
          if (mounted) {
            setState(() => _showShimmer = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget logoImage = Image.asset(widget.config.imagePath, width: widget.config.width);

    // Apply offset if specified
    if (widget.config.imageOffset != null) {
      logoImage = Transform.translate(offset: widget.config.imageOffset!, child: logoImage);
    }

    return MultiStateSheetBuilder<ThreeStateSheet>(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) {
        // Fades out on the way to "expanded" too, instead of staying pinned
        // at full visibility for every non-hidden state — but only over the
        // last third of the "open" state's range, so it stays fully visible
        // until the sheet is nearly fully expanded.
        final opacity = switch (state) {
          ThreeStateSheet.hidden => clampDouble(interpolation * 3, 0, 1),
          ThreeStateSheet.open => clampDouble((1 - interpolation) * 3, 0, 1),
          ThreeStateSheet.expanded => 0.0,
        };
        return IgnorePointer(
          ignoring: opacity == 0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();

          // Trigger fireworks if supported
          if (widget.config.supportsFireworks && widget.fireworksController != null) {
            widget.fireworksController!
              ..value = 0
              ..animateTo(
                widget.fireworksController!.upperBound,
                curve: Curves.easeOutQuint,
                duration: widget.fireworksController!.duration,
              );
          }

          // Scale animation
          scaleController
            ..value = 0
            ..animateTo(1, curve: Curves.easeOut);
        },
        onTapDown: (_) => scaleController
          ..value = 0
          ..animateTo(.4, curve: Curves.easeOut),
        onLongPressEnd: (details) {
          scaleController.animateTo(1, curve: Curves.easeOut);
          widget.onTap?.call();
        },
        child: Align(
          alignment: widget.config.alignment,
          child: Padding(
            padding: widget.config.padding,
            child: ScaleTransition(
              scale: Tween<double>(begin: .9, end: 1.0).animate(scaleController),
              child: Stack(
                children: [
                  logoImage,
                  if (_showShimmer && widget.config.hasShimmer && widget.config.shimmerGradient != null)
                    Opacity(
                      opacity: 0.6,
                      child: Shimmer(
                        period: widget.config.shimmerPeriod,
                        gradient: widget.config.shimmerGradient!,
                        child: logoImage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
