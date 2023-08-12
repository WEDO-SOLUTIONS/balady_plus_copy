import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/models/daem_item.dart';
import '../core/bloc/category_bloc/daem_category_bloc.dart';

class DaemTypeDialog extends StatefulWidget {
  final List<DaemItem>? categories;

  const DaemTypeDialog({Key? key, this.categories}) : super(key: key);

  @override
  State<DaemTypeDialog> createState() => _DaemTypeDialog();
}

class _DaemTypeDialog extends State<DaemTypeDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaemCategoryBloc(categories: widget.categories),
      child: BlocConsumer<DaemCategoryBloc, DaemCategoryState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.error ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // types
                  state.status == BlocStatus.retry
                      ? ReloadWidget(
                          onTab: () {
                            context
                                .read<DaemCategoryBloc>()
                                .add(GetDaemCategoryEvent());
                          },
                        )
                      : state.categoryTypeList != null
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                bottom: Constants.mediumPadding,
                                left: Constants.semiMediumPadding,
                                right: Constants.semiMediumPadding,
                              ),
                              itemCount: state.categoryTypeList?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return DaemTypeWidget(
                                    name: state.categoryTypeList![index],
                                    icon: getIcon(
                                        state.categoryTypeList![index].id!));
                              },
                            )
                          : Container()
                ],
              ),
              if (state.status == BlocStatus.loading)
                Align(
                  child: CustomCircularLoadingWidget(),
                  alignment: Alignment.center,
                ),
            ],
          );
        },
      ),
    );
  }
}

class DaemTypeWidget extends StatelessWidget {
  DaemItem name;
  String icon;

  DaemTypeWidget({required this.name, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        /* bool isSuccess = true;
        if (isSuccess) {
          NavigationService.navigatorKey.currentState!.pushNamed(
              RoutesNames.newGeneralInquiryRoute,
              arguments: inqTypesModel);
        }*/
        context
            .read<DaemCategoryBloc>()
            .add(GetDaemMunicipalitiesAndSubCategoryEvent(name));
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
        margin: const EdgeInsets.only(bottom: Constants.smallPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.semiMediumPadding,
          vertical: Constants.mediumPadding,
        ),
        child: Row(
          children: [
            // icon
            SvgPicture.asset(
              icon.isNotEmpty
                  ? icon
                  : Constants.imgPath + "iconCard60CustomerSupport@3x.png",
              height: 38,
              width: 38,
            ),
            Constants.horizontalSpaceSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  CustomTextWidget(
                    name.name ?? "",
                    fontColor: AppColor.black,
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getIcon(String category) {
  switch (category) {
    case "السكن الجماعي":
      return 'assets/images/inq/Inq_1.svg';
    case "المخططات":
      return 'assets/images/inq/Inq_2.svg';
    case "الرخص الإنشائية":
      return 'assets/images/inq/Inq_3.svg';
    case "كود البناء والتأمين السكني":
      return 'assets/images/inq/Inq_4.svg';
    case "الايواء":
      return 'assets/images/inq/Inq_5.svg';
    case "الرخص التجارية":
      return 'assets/images/inq/Inq_6.svg';
    case "إكرام الموتى":
      return 'assets/images/inq/Inq_8.svg';
    case "الشهادات الصحية":
      return 'assets/images/inq/Inq_9.svg';
    case "منصة ممتثل":
      return 'assets/images/inq/Inq_10.svg';
    case "تصنيف مقدمي خدمات المدن":
      return 'assets/images/inq/Inq_11.svg';
    case "صوت العميل":
      return 'assets/images/inq/Inq_12.svg';
    case "رخص الحفريات":
      return 'assets/images/inq/Inq_13.svg';
    case "الفرص الاستثمارية":
      return 'assets/icons/iconServicesCustomerVoiceMarket.svg';
    case "المتاجر المتنقلة":
      return "";
    case "التبغ":
      return "assets/images/inq/Inq_20.svg";
    default:
      return IconPath.calendarIcon;
  }
}
