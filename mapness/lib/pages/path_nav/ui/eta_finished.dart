import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaFinished extends ConsumerStatefulWidget {
  final VoidCallback onEndTripPressed;
  const EtaFinished({
    required this.onEndTripPressed,
    super.key,
  });

  @override
  ConsumerState<EtaFinished> createState() => _EtaFinishedState();
}

class _EtaFinishedState extends ConsumerState<EtaFinished> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IgnorePointer(
          ignoring: !_isExpanded,
          child: GestureDetector(
            onTap: _isExpanded ? toggle : null,
            child: AnimatedContainer(
              duration: BaseRoadPanel.animationDuration,
              height: media.size.height,
              width: media.size.width,
              curve: BaseRoadPanel.animationCurve,
              color: Colors.black.withOpacity(_isExpanded ? 0.7 : 0.0),
            ),
          ),
        ),
        Material(
          color: _isExpanded ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedPadding(
            padding: EdgeInsets.only(
              left: _isExpanded ? 0 : 16,
              right: _isExpanded ? 0 : 16,
              bottom: media.padding.bottom,
            ),
            duration: BaseRoadPanel.animationDuration,
            curve: BaseRoadPanel.animationCurve,
            child: BaseRoadPanel(
              roadPanelModel: RoadPanelModelArrived(
                enabledHeader: _isExpanded,
                title: context.l10n.youArrived,
                onTapBurger: toggle,
                buttons: [
                  AppButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: NumericBase.$4x),
                    buttonColorScheme: ButtonColorScheme.primary,
                    primaryLabel: context.l10n.endTrip,
                    onTap: widget.onEndTripPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
