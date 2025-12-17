import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapness/pages/kiblah/ui/radar_painter.dart';

class RadarWidget extends StatefulWidget {
  const RadarWidget({
    required this.backgroundColor,
    required this.radarColor,
    super.key,
  });

  final Color backgroundColor;
  final Color radarColor;

  @override
  State<StatefulWidget> createState() => RadarWidgetState();
}

class RadarWidgetState extends State<RadarWidget> with TickerProviderStateMixin {
  double updateTime = 0;

  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    if (_ticker != null) {
      _ticker?.dispose();
    }
    _ticker = createTicker(
      (elapsed) {
        updateTime = elapsed.inMilliseconds / 1000;
        setState(() {});
      },
    )..start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => FutureBuilder<FragmentProgram>(
          future: _initShader(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final shader = snapshot.data!.fragmentShader();

              try {
                shader
                  ..setFloat(0, constraints.maxWidth)
                  ..setFloat(1, constraints.maxHeight)
                  ..setFloat(2, widget.backgroundColor.red / 255)
                  ..setFloat(3, widget.backgroundColor.green / 255)
                  ..setFloat(4, widget.backgroundColor.blue / 255)
                  ..setFloat(5, widget.backgroundColor.alpha / 255)
                  ..setFloat(6, widget.radarColor.red / 255)
                  ..setFloat(7, widget.radarColor.green / 255)
                  ..setFloat(8, widget.radarColor.blue / 255)
                  ..setFloat(9, widget.radarColor.alpha / 255)
                  ..setFloat(10, updateTime);
                // ignore: avoid_catches_without_on_clauses
              } catch (e) {
                return Text('Shader $e');
              }

              return CustomPaint(
                painter: RadarPainter(shader, updateTime),
                child: Container(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );

  Future<FragmentProgram> _initShader() => FragmentProgram.fromAsset(
        'shaders/radar.frag',
      );
}
