import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class ColorPickerOverlay extends StatelessWidget {
  const ColorPickerOverlay({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorList = context.colors.colorList();
    final colorEntity = colorList.firstWhereOrNull(
      (element) => element.color == color,
    );
    return Container(
      // width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12.0,
            color: Colors.black12,
            offset: Offset(0.0, 8.0),
          ),
        ],
      ),
      alignment: Alignment.bottomRight,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              colorEntity?.name ?? '-',
              style: TextStyle(
                color: getTextColorOnBackground(color),
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              colorToHexString(color),
              style: TextStyle(
                color: getTextColorOnBackground(color),
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
