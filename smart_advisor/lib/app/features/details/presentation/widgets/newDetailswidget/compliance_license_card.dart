import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/filter_dialog.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../select_activity/domain/entities/activity_details_page_params.dart';

class ComplianceLicenseCard extends StatelessWidget {
  final int number;
  const ComplianceLicenseCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -35,
                child: Container(
                  height: 41,
                  width: 41,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: FittedBox(
                    child: Container(
                      height: 31,
                      width: 31,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.textPrimaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        "0" + number.toString(),
                        textAlign: TextAlign.center,
                        style: AppStyle.footNoteBoldStyle
                            .copyWith(color: AppColor.surfacePrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 24, left: 16, right: 23),
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الإلتزام والإمتثال",
                        style: AppStyle.somarSemiBold.copyWith(
                            color: AppColor.textPrimaryColor, fontSize: 16),
                      ),
                      SvgPicture.asset(IconPath.complianceIcon)
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                      "ستتلقى زيارات دورية من مراقبي البلدية للتحقق من التزام عملك بالإشتراطات. تعاونك خلال الزيارة سيسهم في تطوير مدينتك وبناء بيئة مزدهرة.",
                      style: AppStyle.textRegularStyle.copyWith(
                          color: AppColor.textSecondaryColor,
                          fontSize: 14,
                          height: 1.7)),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.violationPage,
                          arguments: context.read<DetailsBloc>().args);

                      /*   showModalBottomSheet(
                        backgroundColor: const Color(0xff000000),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => FilterDialog(),
                      );*/
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff568F64).withOpacity(0.21)),
                        color: const Color(0x68F64).withOpacity(0.04),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "عرض قوائم التفحص",
                            style: AppStyle.footNoteRomanStyle.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                          SvgPicture.asset(IconPath.stepArrowIcon)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.ratingItemsPage,
                              arguments: ActivityDetailsPageParams(
                                workFlow: [],
                                isFromHome: false,
                                activityId:
                                    context.read<DetailsBloc>().args.activityId,
                              ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff568F64).withOpacity(0.21)),
                        color: const Color(0x68F64).withOpacity(0.04),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "تقييم درجة امتثال منشأتك",
                            style: AppStyle.footNoteRomanStyle.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                          SvgPicture.asset(IconPath.stepArrowIcon)
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
