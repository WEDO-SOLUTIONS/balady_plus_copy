import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart'
    show
        CustomInkWellButtonWidget,
        CustomPrimaryButton,
        EtmamCustomPrimaryButton;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/bidding_type/bidding_type_bloc.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_drop_down_component.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_warning_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/services/local/helpers.dart';
import '../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../app/core/utils/constants/constants.dart';
import '../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import '../../../_shared_feature_/shared/presentation/widgets/custom_network_icon_widget.dart';

class BiddingTypeDialog extends StatefulWidget {
  BiddingTypeDialog({Key? key}) : super(key: key);

  @override
  State<BiddingTypeDialog> createState() => _BiddingTypeDialog();
}

class _BiddingTypeDialog extends State<BiddingTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BiddingTypeBloc(findByRequestType: sl()),
      child: BlocConsumer<BiddingTypeBloc, BiddingTypeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Helpers.translatingWord("select_bidding_type"),
              withBackImg: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BidddingWarningWidget(),
                  // button, title,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomVerticalSpace(height: 18.0),
                      // subtitle
                      /*CustomTextWidget(
                        Helpers.translatingWord(
                            "customerVoiceSelectReportTypeWord"),
                        fontColor: AppColors.black400,
                        fontWeight: FONT_WEIGHT.medium,
                      ),*/
                      Constants.verticalSpaceSmall,
                    ],
                  ),

                  if (state.status == BlocStatus.loading)
                    Expanded(
                      child: CustomLoadingWidget(),
                    ),
                  if (state.status == BlocStatus.failure)
                    Expanded(
                      child: ReloadWidget(onTab: () {
                        context
                            .read<BiddingTypeBloc>()
                            .add(FindByRequestTypeEvent());
                      }),
                    ),
                  if (state.status == BlocStatus.success) ...[
                    BiddingDropDownListAddetionalField(
                        fieldName: trans("select_bidding_type"),
                        items: state.releationResponseDropDowns ?? [],
                        currentItem: DropDownItem(
                            id: state.selectedResponse?.id,
                            name: state.selectedResponse?.name ?? ""),
                        onChanged: (DropDownItem? item) {
                          BiddingTypeResponse? res = state.releationResponse
                              ?.firstWhere((element) => element.id == item?.id);
                          if (res != null)
                            context
                                .read<BiddingTypeBloc>()
                                .add(ChangeReleationSelectionEvent(item: res));
                        },
                        isMandatory: true,
                        onEmptyList: () {}),
                    if (state.selectedResponse != null) ...[
                      CustomTextWidget(
                        Helpers.translatingWord("sub_service_type"),
                        fontColor: AppColor.baladyDarkGreen2,
                        fontSize: 16.0,
                        fontWeight: AppFontWeight.medium,
                      ),
                      CustomVerticalSpace(height: 16),
                      Expanded(
                          child: ListView.builder(
                              itemCount: state
                                      .selectedResponse?.subRelations?.length ??
                                  0,
                              itemBuilder: (ctx, index) {
                                return CustomCheckBoxWidget(
                                    key: UniqueKey(),
                                    onSelected: (bool? isSelected) {
                                      context.read<BiddingTypeBloc>().add(
                                          ChangeSubReleationSelection(
                                              index: index,
                                              isSelected: isSelected ?? false));
                                    },
                                    backgroundColor: Colors.transparent,
                                    checkboxValue: (state
                                                .selectedResponse
                                                ?.subRelations?[index]
                                                .isSelected ??
                                            false) ||
                                        (state
                                                .selectedResponse
                                                ?.subRelations?[index]
                                                .mandatory ??
                                            false),
                                    title: state
                                            .selectedResponse
                                            ?.subRelations?[index]
                                            .nameWithOptional ??
                                        "");
                              }))
                    ],
                    EtmamCustomPrimaryButton(
                      isBtnDisabled: state.selectedResponse == null,
                      textColor: state.selectedResponse == null
                          ? AppColor.black400
                          : AppColor.white,
                      onPressed: () {
                        NavigationService.pushNamed(
                            routeName: EtmamRoutesNames.biddingForm,
                            args: BiddingFormParams(
                                relation: state.selectedResponse!));
                      },
                      btnText: trans("confirm"),
                      btnHeight: 56,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VDCardWidgetInDialog extends StatelessWidget {
  final VoidCallback btnPressed;
  final String title;
  final String icon;

  const VDCardWidgetInDialog(
      {Key? key,
      required this.title,
      required this.icon,
      required this.btnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: btnPressed,
      widget: Container(
        height: 150,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                    borderRadius: BorderRadius.circular(24),
                    color: AppColor.white),
                height: 134,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    CustomNetworkImageWidget(
                      icon,
                      imageHeight: 96,
                      imageFit: BoxFit.fitWidth,
                      placeHolderWidget: Container(
                        color: Colors.transparent,
                        height: 96,
                      ),
                    ),
                    const CustomVerticalSpace(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomTextWidget(
                        title,
                        fontSize: 14,
                        fontColor: AppColor.black,
                        fontWeight: AppFontWeight.bold,
                        maxLines: 2,
                        height: 1.5,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckBoxWidget extends StatefulWidget {
  final double height;
  final double width;
  final Color borderColor;
  final Color borderSelectedColor;
  final double borderRadius;
  final void Function(bool?)? onSelected;
  final Color backgroundColor;
  final Color containerBackgroundColor;
  final Color backgroundSelectedColor;
  final double space;
  final EdgeInsetsGeometry? padding;
  final double horizontalPadding;
  final double verticalPadding;
  final double checkboxSize;
  final Color checkboxSelectedColor;
  final Color checkboxUnSelectedColor;
  final bool checkboxValue;
  final String title;
  final Color titleColor;
  final double titleSize;
  final AppFontWeight titleFontWeight;
  final double titleHeight;
  final AlignmentDirectional checkBoxAlignment;

  const CustomCheckBoxWidget(
      {Key? key,
      this.height = 60.0,
      this.width = double.infinity,
      this.borderColor = Colors.transparent,
      this.borderSelectedColor = AppColor.darkTurquoise,
      this.borderRadius = 4.0,
      required this.onSelected,
      this.backgroundColor = AppColor.black100,
      this.containerBackgroundColor = Colors.transparent,
      this.backgroundSelectedColor = AppColor.duckEggBlue,
      this.space = 4.0,
      this.padding,
      this.horizontalPadding = 16.0,
      this.verticalPadding = 0.0,
      this.checkboxSize = 1.15,
      this.checkboxSelectedColor = AppColor.darkTurquoise,
      this.checkboxUnSelectedColor = AppColor.white,
      required this.checkboxValue,
      required this.title,
      this.titleColor = AppColor.black,
      this.titleSize = 14.0,
      this.titleFontWeight = AppFontWeight.medium,
      this.titleHeight = 25.0,
      this.checkBoxAlignment = AlignmentDirectional.centerStart})
      : super(key: key);

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {
  late ValueNotifier<bool> _checkBoxValue;

  @override
  void initState() {
    super.initState();
    _checkBoxValue = ValueNotifier<bool>(widget.checkboxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.height,
      // width: widget.width,
      alignment: widget.checkBoxAlignment,
      margin: const EdgeInsets.only(bottom: Constants.semiMediumPadding),
      decoration: BoxDecoration(
          border: Border.all(
            color: widget.checkboxValue
                ? widget.borderSelectedColor
                : widget.borderColor,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.containerBackgroundColor),
      child: ValueListenableBuilder<bool>(
          valueListenable: _checkBoxValue,
          builder: (context, value, child) {
            return ListTile(
              onTap: () {
                _checkBoxValue.value = !value;
                widget.onSelected!(_checkBoxValue.value);
              },
              selected: widget.checkboxValue,
              tileColor: widget.backgroundColor,
              selectedTileColor: widget.backgroundSelectedColor,
              horizontalTitleGap: widget.space,
              minLeadingWidth: 0.0,
              minVerticalPadding: 0.0,
              contentPadding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                    vertical: widget.verticalPadding,
                  ),
              leading: Transform.scale(
                scale: widget.checkboxSize,
                child: Checkbox(
                  value: value,
                  activeColor: widget.checkboxSelectedColor,
                  onChanged: (newVal) {
                    _checkBoxValue.value = newVal!;
                    widget.onSelected!(_checkBoxValue.value);
                  },
                ),
              ),
              title: Container(
                // color: Colors.blue,
                //  height: widget.titleHeight,
                alignment: AlignmentDirectional.centerStart,
                child: CustomTextWidget(
                  widget.title,
                  fontWeight: widget.titleFontWeight,
                  fontColor: widget.titleColor,
                  textAlign: TextAlign.start,
                  fontSize: widget.titleSize,
                  height: 1.3,
                ),
              ),
            );
          }),
    );
  }
}
