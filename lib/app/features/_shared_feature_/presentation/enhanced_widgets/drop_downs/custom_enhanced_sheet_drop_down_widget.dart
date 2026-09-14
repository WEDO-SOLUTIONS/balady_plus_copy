import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocConsumer, BlocProvider, ReadContext;
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, AppStyle, BorderConversion, BorderType, ContextConversion, UIHelper, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show
        BottomSheetDialog,
        CustomTextWidget,
        DrawLineWidget,
        DropDownComponent,
        DropDownItem,
        ErrorUnderWidget,
        GlowingScrollWidget,
        IconButtonWidget,
        OnBackToDefault,
        OnSearching,
        OnUpdating,
        SearchField,
        SheetDropDownBloc,
        SheetDropDownState,
        WidgetLabel;

class CustomEnhancedSheetDropDownWidget extends StatelessWidget {
  final bool isRequired;
  final bool readOnly;
  final DropDownItem? initialValue;
  final List<DropDownItem> items;

  final String? label;
  final TextStyle? labelStyle;

  final String? hintText;
  final TextStyle? hintStyle;

  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final BorderType? borderType;
  final EdgeInsetsGeometry? padding;

  final String? errorMsg;

  final void Function(DropDownItem?) onSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDisabledTapped;
  const CustomEnhancedSheetDropDownWidget({
    super.key,
    this.isRequired = true,
    this.readOnly = false,
    this.initialValue,
    required this.items,
    this.label,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.fillColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderType,
    this.padding,
    this.errorMsg,
    required this.onSelected,
    this.onTap,
    this.onDisabledTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SheetDropDownBloc>(
      create: (_) => SheetDropDownBloc(initialItems: items),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label widget
          WidgetLabel(isRequired: isRequired, label: label, labelStyle: labelStyle),
          //! Drow-Down widget
          Builder(
            builder: (context) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: readOnly
                    ? onDisabledTapped
                    : () async {
                        if (onTap != null) onTap!();
                        await showDropDown(context);
                      },
                child: Container(
                  padding: _padding,
                  decoration: BoxDecoration(color: _fillColor, border: _border, borderRadius: _borderRadius),
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hint widget
                          BlocConsumer<SheetDropDownBloc, SheetDropDownState>(
                            listenWhen: (previous, current) => previous.selectedItem != current.selectedItem,
                            listener: (_, state) => onSelected(state.selectedItem),
                            buildWhen: (previous, current) => previous.selectedItem != current.selectedItem,
                            builder: (_, state) => SizedBox(
                              width: constraints.maxWidth * 0.90,
                              child: CustomTextWidget(state.selectedItem?.name ?? initialHint, textStyle: _hintStyle),
                            ),
                          ),
                          // Arrow widget
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: SizedBox(
                              width: constraints.maxWidth * 0.05,
                              child: _ArrowIconWidget(readOnly: readOnly),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Error widget
          ErrorUnderWidget(errorText: errorMsg),
        ],
      ),
    );
  }

  EdgeInsetsGeometry get _padding =>
      padding ??
      const EdgeInsets.symmetric(horizontal: UIHelper.middlePadding - 2.0, vertical: UIHelper.middlePadding + 1.0);
  BorderType get _borderType => borderType ?? BorderType.outline;
  Color get _fillColor => readOnly ? AppColor.gray : fillColor ?? AppColor.white;
  BoxBorder? get _border => _borderType.boxBorder(color: borderColor ?? AppColor.gray);
  BorderRadiusGeometry? get _borderRadius => _borderType.boxBorderRadius(radius: borderRadius);

  TextStyle get _hintStyle => hintStyle ?? AppStyle.pickerStyle;
  String get initialHint => hintText ?? "selectFromHere".tr();

  Future<void> showDropDown(BuildContext context) async => await BottomSheetDialog.showSheet(
    context,
    isFullHeight: true,
    enableDrag: true,
    child: BlocProvider.value(
      value: context.read<SheetDropDownBloc>()..add(const OnBackToDefault()),
      child: _SheetBodyWidget(title: label),
    ),
  );
}

class _ArrowIconWidget extends StatelessWidget {
  final bool readOnly;
  const _ArrowIconWidget({required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Icon(Icons.arrow_back_ios_new, size: 14.0, color: readOnly ? AppColor.black : AppColor.gray),
    );
  }
}

class _SheetBodyWidget extends StatelessWidget {
  final String? title;
  const _SheetBodyWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIHelper.smallPadding, vertical: UIHelper.middlePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          _DialogHeader(title: title ?? ""),
          // Search Field
          SearchField(onChanged: (term) => context.read<SheetDropDownBloc>().add(OnSearching(query: term))),
          // Line
          DrawLineWidget(lineColor: AppColor.black.withValues(alpha: 0.3)),
          // Items
          const Expanded(child: _BodyItemsWidget()),
        ].addPadding(bottom: 12.0),
      ),
    );
  }
}

class _BodyItemsWidget extends StatelessWidget {
  const _BodyItemsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SheetDropDownBloc, SheetDropDownState>(
      buildWhen: (previous, current) => previous.items != current.items,
      builder: (_, state) {
        final items = state.items;
        return GlowingScrollWidget(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 20.0),
            itemCount: state.items.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropDownComponent(
                isSelected: state.selectedItem == items[index],
                dropDownText: items[index].name,
                dropDownIcon: Icons.yard,
                onPressed: () {
                  // close sheet
                  context.popDialog();
                  // close Bloc
                  context.read<SheetDropDownBloc>().add(OnUpdating(index: index));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;

  const _DialogHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        SizedBox(
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonWidget.close(onPressed: context.popDialog),
              Expanded(
                child: CustomTextWidget(
                  title,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 17,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              // Same size of close button
              const SizedBox(width: 28.0),
            ],
          ),
        ),
        //
        DrawLineWidget(lineColor: AppColor.black.withValues(alpha: 0.3)),
      ].addPadding(bottom: 12.0),
    );
  }
}
