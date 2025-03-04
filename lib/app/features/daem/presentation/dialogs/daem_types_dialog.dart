import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/models/daem_item.dart';
import '../core/bloc/category_bloc/daem_category_bloc.dart';

class DaemTypeScreen extends StatefulWidget {
  final List<DaemItem>? categories;

  const DaemTypeScreen({Key? key, this.categories}) : super(key: key);

  @override
  State<DaemTypeScreen> createState() => _DaemTypeDialog();
}

class _DaemTypeDialog extends State<DaemTypeScreen> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.typesServiceDaem);

    CommonFunctions.sendUXCamEvent(UXCamEvents.Daem_Open_Types_Dialog_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaemCategoryBloc(categories: widget.categories),
      child: Scaffold(
        appBar: AppBar(
          title: Text("daem_select_category".tr()),
        ),
        body: BlocConsumer<DaemCategoryBloc, DaemCategoryState>(
          listener: (context, state) {
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.error ?? "");
            }
          },
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const Align(
                alignment: Alignment.center,
                child: CustomCircularLoadingWidget(),
              );
            }

            return state.status == BlocStatus.retry
                ? ReloadWidget(
                    onTab: () {
                      context
                          .read<DaemCategoryBloc>()
                          .add(GetDaemCategoryEvent());
                    },
                  )
                : state.categoryTypeList != null
                    ? ListView.builder(
                        // physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: Constants.mediumPadding,
                          horizontal: Constants.semiMediumPadding,
                        ),
                        itemCount: state.categoryTypeList?.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return DaemTypeWidget(
                            name: state.categoryTypeList![index],
                            icon: getIcon(
                                state.categoryTypeList![index].name ?? ""),
                          );
                        },
                      )
                    : Container();
          },
        ),
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
    case "خدمة الرخص الإنشائية":
      return IconPath.tsr_1;
    case "خدمة اعتماد المخططات الخاصة":
      return IconPath.tsr_2;
    case "مسار منصة الحفريات":
      return IconPath.tsr_3;
    case "نظام المتاجر المتنقلة":
      return IconPath.tsr_4;
    case "خدمة تصنيف مقدمي خدمات المدن":
      return IconPath.tsr_5;
    case "خدمة الفرص الإستثمارية":
      return IconPath.tsr_6;
    case "صوت العميل":
      return IconPath.tsr_7;
    case "رمز الاستجابة السريع":
      return IconPath.tsr_8;
    case "خدمة الدمج والتجزئة":
      return IconPath.tsr_9;
    case "خدمة الرخص التجارية":
      return IconPath.tsr_10;

    default:
      return IconPath.calendarIcon;
  }
}
