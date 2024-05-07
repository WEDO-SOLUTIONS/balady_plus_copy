/*import 'package:balady_new_app/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomInkWellButtonWidget,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DropDownItem,
        CustomCachedNetworkImage,
        FONT_WEIGHT,
        CustomCheckBoxWidget,
        Helpers;
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/core/shared_local_services/common.dart';
import 'package:balady_new_app/app/core/shared_local_services/enums.dart';
import 'package:balady_new_app/app/core/shared_local_services/routes_names.dart';
import 'package:balady_new_app/app/core/shared_widgets/reload_widget.dart';
import 'package:balady_new_app/app/features/vd/vd_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/bidding_type/bidding_type_bloc.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_drop_down_component.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_type_widget.dart';
import 'package:balady_new_app/shared/core/services/services_exports.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomShimmerGridViewWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // button, title,
              Padding(
                padding: const EdgeInsets.only(
                  top: Constants.semiMediumPadding,
                  left: Constants.semiMediumPadding,
                  right: Constants.semiMediumPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // close button
                    CustomTextButtonWidget(
                      btnPressed: () => Navigator.of(context).pop(),
                      btnText: Helpers.translatingWord(
                        "popUpCloseBottomSheetButton",
                      ),
                      btnTextColor: AppColors.grey1000,
                      btnTextSize: 17.0,
                      btnTextWeight: FONT_WEIGHT.medium,
                    ),
                    Constants.verticalSpaceMedium,
                    // title
                    CustomTextWidget(
                      Helpers.translatingWord("select_bidding_type"),
                      fontColor: AppColors.black,
                      fontSize: 24.0,
                    ),
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
              ),
              if (state.status == BlocStatus.loading)
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: Constants.mediumPadding,
                      left: Constants.semiMediumPadding,
                      right: Constants.semiMediumPadding,
                      top: Constants.smallPadding),
                  child: CustomShimmerGridViewWidget(
                    height: 100,
                    mainAxisExtent: 150,
                  ),
                )),

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
                      name: state.selectedResponse?.name),
                      
                ),
                if (state.selectedResponse != null)
                  Expanded(
                      child: ListView.builder(
                          itemCount:
                              state.selectedResponse?.subRelations?.length ?? 0,
                          itemBuilder: (ctx, indedx) {
                            return CustomCheckBoxWidget(
                                onSelected: (bool? isSelected) {},
                                checkboxValue: true,
                                title: "");
                          })),
              ],
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      bottom: Constants.mediumPadding,
                      left: Constants.semiMediumPadding,
                      right: Constants.semiMediumPadding,
                      top: Constants.smallPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 19.0,
                      mainAxisSpacing: 18.0,
                      mainAxisExtent: 150),
                  itemCount: state.releationResponse?.length ?? 0,
                  itemBuilder: (context, index) => BiddingTypeWidgt(
                      name: state.releationResponse?[index].name ?? "",
                      logoUrl:
                          state.releationResponse?[index].service?.logoUrl ??
                              "",
                      onPress: () async {
                        NavigationService.pushNamed(
                            routeName: EtmamRoutesNames.biddingForm,
                            args: BiddingFormParams(
                                relation: state.releationResponse![index]));
                      }),
                ),
              )
            ],
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
                    color: AppColors.white),
                height: 134,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    CustomCachedNetworkImage(
                      icon,
                      imageHeight: 96,
                      imageFit: BoxFit.fitWidth,
                      placeHolderWidget: Container(
                        color: Colors.transparent,
                        height: 96,
                      ),
                    ),
                    CustomVerticalSpace(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: CustomTextWidget(
                        title,
                        fontSize: 14,
                        fontColor: AppColors.black,
                        fontWeight: FONT_WEIGHT.bold,
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
*/
