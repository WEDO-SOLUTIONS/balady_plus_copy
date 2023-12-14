import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Widget to show/hide traffic and parkings on map
class TrafficParkingControlWidget extends StatefulWidget {
  ///no doc
  const TrafficParkingControlWidget({
    required this.controller,
    super.key,
  });

  final NaviTrafficParkingController controller;

  @override
  State<StatefulWidget> createState() => _TrafficParkingState();
}

class _TrafficParkingState extends State<TrafficParkingControlWidget> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.controller.onAttached());
  }

  @override
  void dispose() {
    unawaited(widget.controller.onDetached());
    super.dispose();
  }

  @override
  Widget build(Object context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Column(
        children: [
          _TrafficWidget(
            stream: widget.controller.trafficStateEvents,
            onPressed: () => unawaited(widget.controller.onTrafficClicked()),
          ),
          const Divider(
            height: 1,
            color: Color(0x14141417),
          ),
          _ParkingWidget(
            stream: widget.controller.parkingStateEvents,
            onPressed: () => unawaited(widget.controller.onParkingClicked()),
          )
        ],
      ),
    );
  }
}

class _ParkingWidget extends StatelessWidget {
  const _ParkingWidget({required this.stream, required this.onPressed});

  final Stream<ParkingStateEvent> stream;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ParkingStateEvent>(
        stream: stream,
        builder: (context, snapshot) {
          final visible = snapshot.data?.visible ?? false;
          return Container(
            width: 44,
            height: 44,
            color: Colors.white,
            child: IconButton(
              onPressed: onPressed,
              icon: SvgPicture.asset(
                "packages/dgis_map/assets/svg/p.svg",
                colorBlendMode: BlendMode.srcIn,
                color:
                    visible ? const Color(0xFF3588FD) : const Color(0xff3C3C3C),
              ),
            ),
          );
        });
  }
}

const Color _trafficGreen = Color(0xff58a600);
const Color _trafficYellow = Color(0xffffba00);
const Color _trafficRed = Color(0xffd15536);

class _TrafficWidget extends StatelessWidget {
  const _TrafficWidget({
    required this.stream,
    required this.onPressed,
  });

  final Stream<TrafficStateEvent> stream;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrafficStateEvent>(
        stream: stream,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final score = snapshot.data!.score;
          final status = snapshot.data!.status;

          if (status == TrafficControlStatus.hidden) {
            return const SizedBox.shrink();
          }

          return Container(
              width: 44,
              height: 44,
              color: Colors.white,
              child: status == TrafficControlStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextButton(
                        onPressed: onPressed,
                        style: TextButton.styleFrom(
                          backgroundColor: _getColorForTraffic(score),
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text("$score",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ));
        }));
  }

  Color _getColorForTraffic(int value) {
    if (value <= 3) {
      return _trafficGreen;
    } else if (value <= 6) {
      return _trafficYellow;
    } else {
      return _trafficRed;
    }
  }
}
