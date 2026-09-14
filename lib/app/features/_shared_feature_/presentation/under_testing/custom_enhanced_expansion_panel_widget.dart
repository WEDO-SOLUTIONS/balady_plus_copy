import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocProvider, Cubit;
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion, DIRECTION, DirectionConversion, UIHelper;
import '../../shared_feature_exports.dart' show CustomAutoSizeTextWidget, DrawIconBasedTypeWidget;

class _ExpansionPanelCubit extends Cubit<bool> {
  final bool initialState;
  _ExpansionPanelCubit({required this.initialState}) : super(initialState);

  void onChangeState(bool currentState) => emit(currentState);
}

class CustomEnhancedExpansionPanelWidget extends StatelessWidget {
  /// Specifies whether the state of the children is maintained
  /// when the tile expands and collapses.
  final bool keepState;

  /// Maybe Widget or String or IconData
  final dynamic leading;
  final String? title;

  /// The body of expansion
  final List<Widget> children;
  final double? expansionWidth;
  // final double expandedHeight;
  final EdgeInsetsGeometry? expandedPadding;
  final bool isExpanded;
  final bool underline;
  final void Function(bool)? onExpansionChanged;
  final double? leadingWidth;
  final Color? backgroundColor;
  const CustomEnhancedExpansionPanelWidget({
    super.key,
    this.keepState = true,
    this.leading,
    this.title,
    this.children = const <Widget>[],
    this.expansionWidth,
    // this.expandedHeight = 300.0,
    this.expandedPadding,
    this.isExpanded = false,
    this.underline = true,
    this.leadingWidth,
    this.backgroundColor,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_ExpansionPanelCubit>(
      create: (_) => _ExpansionPanelCubit(initialState: isExpanded),
      child: Builder(
        builder: (context) => BlocBuilder<_ExpansionPanelCubit, bool>(
          builder: (_, expansionState) {
            return Container(
              width: expansionWidth ?? context.screenWidth,
              // padding: expandedPadding ??
              //     const EdgeInsets.symmetric(
              //       horizontal: UIHelper.semiMediumPadding,
              //       vertical: 8.0,
              //     ),
              decoration: BoxDecoration(
                color: backgroundColor ?? Color(0x7FE6EFEF),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: LayoutBuilder(
                builder: (_, constraints) => SizedBox(
                  width: constraints.maxWidth,
                  child: Theme(
                    data: ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      horizontalTitleGap: 0,
                      minLeadingWidth: leadingWidth ?? 25.0,
                      minVerticalPadding: 0.0,
                      selectedColor: Colors.transparent,
                      selectedTileColor: Colors.transparent,
                      child: ExpansionTile(
                        tilePadding: tilePadding,
                        childrenPadding: childrenPadding,
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        maintainState: keepState,
                        initiallyExpanded: expansionState,
                        leading: _ExpansionLeadingWidget(expanded: expansionState, leading: leading),
                        title: _ExpansionTitleWidget(expanded: expansionState, title: title),
                        trailing: _ExpansionPanelArrowWidget(expanded: expansionState),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        onExpansionChanged: (state) {
                          BlocProvider.of<_ExpansionPanelCubit>(context).onChangeState(state);
                          if (onExpansionChanged != null) {
                            onExpansionChanged!(expansionState);
                          }
                        },
                        children: children,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BorderSide border(bool state) => underline
      ? BorderSide(width: state ? 1.5 : 1.0, color: state ? AppColor.gray : AppColor.gray.withValues(alpha: 0.36))
      : BorderSide.none;

  // get horizontal padding from expandedPadding but divide it by 2
  // to get the half for right and second half for left
  // and get vetical padding and divide it by 2 for only top
  EdgeInsetsGeometry get tilePadding => EdgeInsets.fromLTRB(
    expandedPadding?.horizontal == null ? UIHelper.middlePadding : expandedPadding!.horizontal / 2.0,
    expandedPadding?.vertical == null ? 4 : expandedPadding!.vertical / 2.0,
    expandedPadding?.horizontal == null ? UIHelper.middlePadding : expandedPadding!.horizontal / 2.0,
    0.0,
  );

  // get horizontal padding from expandedPadding but divide it by 2
  // to get the half for right and second half for left
  EdgeInsetsGeometry get childrenPadding => EdgeInsets.fromLTRB(
    expandedPadding?.horizontal == null ? UIHelper.middlePadding : expandedPadding!.horizontal / 2.0,
    8.0,
    expandedPadding?.horizontal == null ? UIHelper.middlePadding : expandedPadding!.horizontal / 2.0,
    UIHelper.mediumPadding,
  );
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
            decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(8.0)),
            child: leading is Widget
                ? leading
                : DrawIconBasedTypeWidget(icon: leading, iconSize: 16.0, iconColor: leadingColor),
          )
        : const SizedBox();
  }

  Color get leadingBGColor => expanded ? AppColor.blue : AppColor.white;
  Color get leadingColor => expanded ? AppColor.black : AppColor.gray;
}

class _ExpansionTitleWidget extends StatelessWidget {
  final String? title;
  final bool expanded;

  const _ExpansionTitleWidget({required this.title, required this.expanded});

  @override
  Widget build(BuildContext context) {
    return CustomAutoSizeTextWidget(
      title ?? "",
      textStyle: textStyle,
      maxLines: 10,
      textOverflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      minFontSize: 12.0,
      // height: 1.3,
    );
  }

  // double get titleWidth => leading == null
  //     ? width - (25.0 + 10.0)
  //     : width - (25.0 + 10.0 + 10.0 + 25.0);
  TextStyle get textStyle => AppStyle.mainTextThirdStyle.copyWith(
    fontSize: 15.0,
    color: AppColor.blackModern600Light,
    fontWeight: FontWeight.bold,
  );
}

class _ExpansionPanelArrowWidget extends StatelessWidget {
  final bool expanded;

  const _ExpansionPanelArrowWidget({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: AppColor.primary900Light, shape: BoxShape.circle),
      child: Transform.rotate(
        angle: angle,
        child: Icon(Icons.arrow_back_ios_new, size: 12, color: iconColor),
      ),
    );
  }

  // because original arrow looks at the left,
  // so, if expanded we need to rotate it by 90', otherwise rotate by 270'
  double get angle => expanded ? DIRECTION.downward.rotate : DIRECTION.upward.rotate;
  Color get iconColor => expanded ? AppColor.white : AppColor.white;
}
