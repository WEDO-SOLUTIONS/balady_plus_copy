import 'package:balady_uikit/core/utils/inspector_plus/src/widgets/inspector/box_info.dart';
import 'package:flutter/material.dart';
import 'box_info_panel_widget.dart';
import 'information_box_widget.dart';
import 'overlay_painter.dart';

class BoxInfoWidget extends StatelessWidget {
  const BoxInfoWidget({
    required this.boxInfo,
    required this.isPanelVisible,
    required this.onPanelVisibilityChanged,
    Key? key,
  }) : super(key: key);

  final BoxInfo boxInfo;

  final bool isPanelVisible;
  final ValueChanged<bool> onPanelVisibilityChanged;

  Color get _targetColor => Colors.green.shade700;
  Color get _containerColor => Colors.deepOrangeAccent.shade700;

  Widget _buildTargetBoxSizeWidget(BuildContext context) {
    return Positioned(
      top: calculateBoxPosition(
        rect: boxInfo.targetRectShifted,
        height: InformationBoxWidget.preferredHeight,
      ),
      left: boxInfo.targetRectShifted.left,
      child: IgnorePointer(
        child: Align(
          child: InformationBoxWidget.size(
            size: boxInfo.targetRect.size,
            color: _targetColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTargetBoxInfoPanel(BuildContext context) {
    return BoxInfoPanelWidget(
      boxInfo: boxInfo,
      targetColor: _targetColor,
      containerColor: _containerColor,
      isVisible: isPanelVisible,
      onVisibilityChanged: onPanelVisibilityChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          child: CustomPaint(
            painter: OverlayPainter(
              boxInfo: boxInfo,
              targetRectColor: _targetColor.withOpacity(0.5),
              containerRectColor: _containerColor.withOpacity(0.5),
            ),
          ),
        ),
        // ..._buildPaddingWidgets(context),
        _buildTargetBoxSizeWidget(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildTargetBoxInfoPanel(context),
          ),
        ),
      ],
    );
  }
}
