import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomInkWellButtonWidget,
        CustomNetworkImageWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelationCheckBoxWidget extends StatefulWidget {
  final String checkBoxText;
  final String? checkBoxIcon;
  final String? checkBoxDesc;
  final double textSize;
  final Color unSelectedBackgroundColor;
  bool isSelected;
  final int index;
  final Widget? buttonWidget;

  RelationCheckBoxWidget(
      {Key? key,
      required this.checkBoxText,
      this.checkBoxIcon,
      this.textSize = 16,
      this.unSelectedBackgroundColor = AppColor.white,
      this.isSelected = false,
      required this.index,
      this.checkBoxDesc,
      this.buttonWidget})
      : super(key: key);

  @override
  State<RelationCheckBoxWidget> createState() => _RelationCheckBoxWidgetState();
}

class _RelationCheckBoxWidgetState extends State<RelationCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationBloc, RelationState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  widget.isSelected ? AppColorsTheme.primary50 : AppColor.white,
              border: Border.all(
                width: 1,
                color: widget.isSelected
                    ? AppColorsTheme.primary700
                    : Colors.transparent,
              )),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInkWellButtonWidget(
                    btnPressed: () {
                      context
                          .read<RelationBloc>()
                          .add(SelectRelationEvent(index: widget.index));
                    },
                    widget: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: widget.isSelected
                          ? const CustomSvgIconWidget(IconPath.checkedIcon,
                              iconSize: 24)
                          : const CustomSvgIconWidget(IconPath.unCheckedIcon,
                              iconSize: 24),
                    ),
                  ),
                  const CustomHorizontalSpace(width: 24),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: CustomNetworkImageWidget(
                            widget.checkBoxIcon ?? "",
                            imageHeight: 48,
                            imageWidth: 48,
                            imageFit: BoxFit.fill,
                          ),
                        ),
                        const CustomHorizontalSpace(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                widget.checkBoxText,
                                fontSize: widget.textSize,
                                fontWeight: AppFontWeight.w600,
                                fontColor: AppColor.black,
                                textAlign: TextAlign.start,
                              ),
                              // if (widget.checkBoxDesc != null &&
                              //     widget.checkBoxDesc!.isNotEmpty)
                              //   CustomTextWidget(
                              //     widget.checkBoxDesc ?? "",
                              //     fontSize: 12,
                              //     fontWeight: AppFontWeight.regular,
                              //     fontColor: AppColor.bottomNavigationShadow,
                              //     textAlign: TextAlign.start,
                              //   )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.buttonWidget != null && widget.isSelected) ...[
                const CustomVerticalSpace(height: 32),
                widget.buttonWidget ?? const Center()
              ]
            ],
          ),
        );
      },
    );
  }
}
