extension ColorDetector on String {
  String? getColorFromCSS(String color, [bool withConst = false]) {
    if (color.length == 6) {
      return '${withConst ? 'const ' : ''}Color(0xFF$color)';
    } else if (color.length == 8) {
      var colorColor = color.substring(0, 6);
      var colorAlpha = color.substring(6);
      return '${withConst ? 'const ' : ''}Color(0x$colorAlpha$colorColor)';
    }
    return null;
  }
}
