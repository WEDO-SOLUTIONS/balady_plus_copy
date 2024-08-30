import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class EtaRouteLine extends StatelessWidget {
  /// progress is a value between 0 and 1
  final double progress;
  final Widget image;

  static const imgSize = 32.0;

  const EtaRouteLine({required this.progress, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final imgPosition = progress > 0.8 ? imgSize : imgSize / 2;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: imgSize,
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(RadiusBorder.full),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 8,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff1CA9A6),
                        Color(0xff84BC47),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(RadiusBorder.full),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: constraints.maxWidth * progress - imgPosition,
              child: SizedBox(
                height: imgSize,
                width: imgSize,
                child: image,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Share trip progress
// static shareTripProgress = 'Share trip progress';

// Route is sharing
// static routeIsSharing = 'Route is sharing';

// Drive ended
// static driveEnded = 'Drive ended';

// The driver reached the destination or is no longer sharing this drive
// static driverReachedDestination = 'The driver reached the destination or is\nno longer sharing this drive';

// Arriving in {time}
// static arrivingInTime = 'Arriving in {time}';

// {km} km away
// static kmAway = '{km} km away';

// Last updated at {time}
// static lastUpdatedAtTime = 'Last updated at {time}';

// I will arrive at {time} to\n\n{destination}\n\n{link}
// static iWillArriveAtTimeToDestinationLink = 'I will arrive at {time} to\n\n{destination}\n\n{link}';



