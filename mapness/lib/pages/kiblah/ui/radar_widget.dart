import 'dart:ui';

import 'package:flutter/material.dart';

import 'radar_painter.dart';

class RadarWidget extends StatefulWidget {
  const RadarWidget({
    super.key,
    required this.backgroundColor,
    required this.radarColor,
  });

  final Color backgroundColor;
  final Color radarColor;

  @override
  State<StatefulWidget> createState() => RadarWidgetState();
}

class RadarWidgetState extends State<RadarWidget>
    with TickerProviderStateMixin {
  var updateTime = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<FragmentProgram>(
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
            } catch (e) {
              return Text("Shader ${e.toString()}");
            }

            return CustomPaint(
              painter: RadarPainter(shader, updateTime),
              child: Container(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset(
      'shaders/radar.frag',
    );
  }
}
