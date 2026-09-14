import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, AppStyle, ContextConversion, DIRECTION, DirectionConversion, UIHelper;
import '../../shared_feature_exports.dart'
    show
        ClickableWidget,
        CustomAutoSizeTextWidget,
        CustomHorizontalSpace,
        DrawIconBasedTypeWidget,
        ExpansionPanelListCubit,
        ExpansionPanelInfo;

class CustomEnhancedExpansionPanelListWidget extends StatefulWidget {
  final Color? bgColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  final List<ExpansionPanelInfo> children;
  final void Function(int, bool)? expansionCallback;
  const CustomEnhancedExpansionPanelListWidget({
    super.key,
    this.bgColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 8.0,
    //
    required this.children,
    this.expansionCallback,
  });

  @override
  State<CustomEnhancedExpansionPanelListWidget> createState() => _CustomEnhancedExpansionPanelListWidgetState();
}

class _CustomEnhancedExpansionPanelListWidgetState extends State<CustomEnhancedExpansionPanelListWidget> {
  late List<ExpandableController> _controllers;

  late List<ExpansionPanelInfo> _children;
  late void Function(int, bool)? _expansionCallback;

  late ExpansionPanelListCubit _panelCubit;

  @override
  void initState() {
    super.initState();
    _children = widget.children;
    _expansionCallback = widget.expansionCallback;

    _controllers = [];
    for (var panel in _children) {
      _controllers.add(ExpandableController(initialExpanded: panel.isExpanded));
    }

    _panelCubit = ExpansionPanelListCubit(initialIndex: _children.indexWhere((panel) => panel.isExpanded));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _panelCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableTheme(
      data: ExpandableThemeData(
        bodyAlignment: context.isRTL ? ExpandablePanelBodyAlignment.right : ExpandablePanelBodyAlignment.left,
        hasIcon: false,
        useInkWell: false,
        tapHeaderToExpand: false,
        tapBodyToCollapse: false,
        tapBodyToExpand: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _children.length,
          (index) => BlocBuilder<ExpansionPanelListCubit, int>(
            bloc: _panelCubit,
            builder: (_, panelIndex) {
              final expansionState = panelIndex == index;
              return _PanelCard(
                controller: _controllers[index],
                bgColor: widget.bgColor,
                borderColor: widget.borderColor,
                borderWidth: widget.borderWidth,
                borderRadius: widget.borderRadius,
                panelInfo: _children[index],
                expansionState: expansionState,
                onUpdated: () => onUpdatePanel(index),
              );
            },
          ),
        ),
      ),
    );
  }

  void onUpdatePanel(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      final controller = _controllers[i];
      if (i == index) {
        controller.toggle();

        final panelExpanded = controller.expanded;
        _panelCubit.onChangeState(panelExpanded ? i : -1);
        if (_expansionCallback != null) {
          _expansionCallback!(i, panelExpanded);
        }
      } else {
        // to close all others
        controller.expanded = false;
      }

      if (_children[i].onExpansionChanged != null) {
        _children[i].onExpansionChanged!(controller.expanded);
      }
    }
  }
}

class _PanelCard extends StatelessWidget {
  final ExpandableController? controller;
  final Color? bgColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  final ExpansionPanelInfo panelInfo;
  final bool expansionState;
  final VoidCallback onUpdated;
  const _PanelCard({
    this.controller,
    required this.bgColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    //
    required this.panelInfo,
    required this.expansionState,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // UI of whole card
      width: panelInfo.expansionWidth ?? double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      // padding: panelInfo.panelPadding ?? panelPadding,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        border: Border.all(color: _borderColor, width: _borderWidth),
      ),
      child: ExpandablePanel(
        controller: controller,
        header: ClickableWidget(
          onPressed: onUpdated,
          child:
              panelInfo.header ??
              Container(
                // UI of header only
                padding: panelInfo.headerPadding ?? headerPadding,
                decoration: BoxDecoration(border: _boxBorder),
                child: _HeaderWidget(
                  expansionState: expansionState,
                  leading: panelInfo.leading,
                  title: panelInfo.title,
                  titleMaxLines: panelInfo.titleMaxLines,
                ),
              ),
        ),
        collapsed: const SizedBox(),
        expanded: Padding(
          // UI of body only
          padding: panelInfo.bodyPadding ?? bodyPadding,
          child: panelInfo.body ?? const SizedBox(),
        ),
      ),
    );
  }

  Color get _bgColor => panelInfo.bgColor ?? bgColor ?? AppColor.ghostWhite;
  Color get _borderColor => panelInfo.borderColor ?? borderColor ?? AppColor.brightGray;
  double get _borderWidth => panelInfo.borderWidth ?? borderWidth;
  double get _borderRadius => panelInfo.borderRadius ?? borderRadius;

  BoxBorder? get _boxBorder => expansionState && panelInfo.underline
      ? const Border(bottom: BorderSide(color: AppColor.brightGray, width: 1.0))
      : null;

  EdgeInsetsGeometry get headerPadding =>
      const EdgeInsetsDirectional.only(top: 16.0, bottom: 16.0, start: 16.0, end: 12.0);
  EdgeInsets get bodyPadding => const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, UIHelper.middlePadding);
}

class _HeaderWidget extends StatelessWidget {
  final bool expansionState;
  final dynamic leading;
  final String? title;
  final int titleMaxLines;
  const _HeaderWidget({
    required this.expansionState,
    required this.leading,
    required this.title,
    required this.titleMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        // 25.0 for leading & 25.0 for trailing
        // 8.0*2 for two spaces
        final titleWidth = leading != null ? width - (25.0 * 2 + 8 * 2) : width - (25.0 + 8.0);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Leading
                if (leading != null) _ExpansionLeadingWidget(expanded: expansionState, leading: leading),
                //* Space
                if (leading != null) const CustomHorizontalSpace(width: 8.0),
                // Title
                SizedBox(
                  width: titleWidth,
                  child: _ExpansionTitleWidget(expanded: expansionState, title: title, maxLines: titleMaxLines),
                ),
              ],
            ),
            //* Space
            const CustomHorizontalSpace(width: 8.0),
            // Trailing
            _ExpansionPanelArrowWidget(expanded: expansionState),
          ],
        );
      },
    );
  }
}

class _ExpansionLeadingWidget extends StatelessWidget {
  final bool expanded;
  final dynamic leading;
  const _ExpansionLeadingWidget({required this.expanded, required this.leading});

  @override
  Widget build(BuildContext context) {
    return leading != null
        ? Container(
            width: 25.0,
            height: 25.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: leadingBGColor, borderRadius: BorderRadius.circular(8.0)),
            child: leading is Widget
                ? leading
                : DrawIconBasedTypeWidget(icon: leading, iconSize: 16.0, iconColor: leadingColor),
          )
        : const SizedBox();
  }

  Color get leadingBGColor => expanded ? AppColor.bleuDeFrance : AppColor.brightGray;
  Color get leadingColor => expanded ? AppColor.indigo : AppColor.uclaBlue;
}

class _ExpansionTitleWidget extends StatelessWidget {
  final String? title;
  final int maxLines;
  final bool expanded;

  const _ExpansionTitleWidget({required this.title, required this.maxLines, required this.expanded});

  @override
  Widget build(BuildContext context) {
    return CustomAutoSizeTextWidget(
      title ?? "notFound".tr(),
      textStyle: textStyle,
      maxLines: maxLines,
      textOverflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      minFontSize: 10.0,
    );
  }

  TextStyle get textStyle =>
      AppStyle.s14.copyWith(color: AppColor.indigo, height: 1.4, fontWeight: AppFontWeight.bold.fontWeight);
}

class _ExpansionPanelArrowWidget extends StatelessWidget {
  final bool expanded;
  const _ExpansionPanelArrowWidget({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: angle,
        child: Icon(Icons.arrow_back_ios_new, size: 18.0, color: iconColor),
      ),
    );
  }

  // because original arrow looks at the left,
  // so, if expanded we need to rotate it by 90', otherwise rotate by 270'
  double get angle => expanded ? DIRECTION.downward.rotate : DIRECTION.upward.rotate;
  Color get iconColor => AppColor.maastrichtBlue;
}
