import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import 'custom_spaces_widgets.dart';
import 'draw_line_widget.dart';

class CustomEnhancedExpansionPanelWidget extends StatefulWidget {
  final Widget? leading;
  final String? title;
  final Widget? child;
  final double? expansionWidth;
  final double expandedHeight;
  final bool expanded;
  final bool underline;

  const CustomEnhancedExpansionPanelWidget({
    super.key,
    this.leading,
    this.title,
    required this.child,
    this.expansionWidth,
    this.expandedHeight = 300.0,
    this.expanded = false,
    this.underline = true,
  });

  @override
  State<CustomEnhancedExpansionPanelWidget> createState() => _CustomEnhancedExpansionPanelWidgetState();
}

class _CustomEnhancedExpansionPanelWidgetState extends State<CustomEnhancedExpansionPanelWidget> {
  // late double _collapsedHeight;
  late bool _expandedStatus;

  late ValueNotifier<bool> _expandedPanelValueNotifier;

  @override
  void initState() {
    super.initState();
    // _collapsedHeight = 0.0;
    _expandedStatus = widget.expanded;
    _expandedPanelValueNotifier = ValueNotifier<bool>(_expandedStatus);
  }

  @override
  void dispose() {
    _expandedPanelValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: widget.expansionWidth ?? screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: GeneralKey.semiMediumPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ValueListenableBuilder<bool>(
            valueListenable: _expandedPanelValueNotifier,
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                _ExpansionPanelHeaderWidget(
                  leading: widget.leading,
                  title: widget.title,
                  width: constraints.maxWidth,
                  expanded: value,
                  expansionCallback: _expansionCallback,
                ),
                // body
                if (widget.child != null)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: value ? widget.child : const SizedBox(),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: GeneralKey.mediumPadding,
                            bottom: value ? GeneralKey.smallPadding : 0.0,
                          ),
                          child: child,
                        ),
                      );
                    },
                  ),
                if (widget.child == null) const CustomVerticalSpace(height: 24),
                if (widget.underline) const DrawLineWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _expansionCallback() => _expandedPanelValueNotifier.value = !_expandedPanelValueNotifier.value;
}

class _ExpansionPanelHeaderWidget extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final double width;
  final bool expanded;
  final VoidCallback expansionCallback;

  const _ExpansionPanelHeaderWidget({
    required this.leading,
    required this.title,
    required this.width,
    required this.expanded,
    required this.expansionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: expansionCallback,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: GeneralKey.mediumPadding),
        child: Row(
          mainAxisAlignment: _getMainAxisAlignment(),
          children: [
            if (leading != null) SizedBox(width: 25.0, child: leading),
            if (leading != null) const CustomHorizontalSpace(width: 10.0),
            if (title != null)
              SizedBox(
                width: _getTitleWidth(),
                child: CustomTextWidget(
                  title!,
                  fontSize: 17.0,
                  fontColor: AppColor.black,
                  fontWeight: leading != null ? AppFontWeight.medium : AppFontWeight.bold,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  height: 1.3,
                ),
              ),
            if (title != null) const CustomHorizontalSpace(width: 10.0),
            _ExpansionPanelArrowWidget(expanded: expanded),
          ],
        ),
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    if (leading == null && title == null) {
      return MainAxisAlignment.end;
    } else if (leading != null && title == null) {
      return MainAxisAlignment.spaceBetween;
    } else {
      return MainAxisAlignment.start;
    }
  }

  double _getTitleWidth() => leading == null ? width - (25.0 + 10.0) : width - (25.0 + 10.0 + 10.0 + 25.0);
}

class _ExpansionPanelArrowWidget extends StatelessWidget {
  final bool expanded;

  const _ExpansionPanelArrowWidget({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.0,
      height: 25.0,
      decoration: const BoxDecoration(color: AppColor.white6, shape: BoxShape.circle),
      child: RotatedBox(quarterTurns: expanded ? 1 : 3, child: const Icon(Icons.arrow_back_ios_new, size: 13.0)),
    );
  }
}
