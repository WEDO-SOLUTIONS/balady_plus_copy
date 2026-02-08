import 'package:flutter/widgets.dart';
import 'package:smooth_corner/smooth_corner.dart';

ShapeBorder smoothBorder(double radius) =>
    SmoothRectangleBorder(smoothness: .6, borderRadius: BorderRadius.circular(radius));
