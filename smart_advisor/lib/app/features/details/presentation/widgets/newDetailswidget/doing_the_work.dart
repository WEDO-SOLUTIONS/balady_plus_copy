import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';

import '../../../../../core/utils/constants/route_names.dart';

class DoingTheWork extends StatelessWidget {
  final int number;
  const DoingTheWork({super.key, required this.number});

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
                        "ممارسة عملك!",
                        style: AppStyle.somarSemiBold.copyWith(
                            color: AppColor.statusAttentionColor, fontSize: 16),
                      ),
                      SvgPicture.asset(IconPath.doingWorkIcon)
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                      "لقد وصلت الى هدفك! الآن انت تملك رخصة تجارية وتمارس عملك التجاري .",
                      style: AppStyle.textRegularStyle.copyWith(
                          color: AppColor.textSecondaryColor,
                          fontSize: 14,
                          height: 1.7)),
                  Text(
                      " إحرص على التزامك بالاشتراطات البلدية الخاصة بنشاطك حتى تحافظ على سريان عملك وتوسعته بنجاح.",
                      style: AppStyle.textRegularStyle.copyWith(
                          color: AppColor.textSecondaryColor,
                          fontSize: 14,
                          height: 1.7)),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.regulationPage,
                          arguments: context.read<DetailsBloc>().args);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff568F64).withOpacity(0.21)),
                        color: const Color(0xff568F64).withOpacity(0.04),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "عرض الإشتراطات الخاصة بنشاطك",
                                    style: AppStyle.footNoteRomanStyle.copyWith(
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(IconPath.stepArrowIcon)
                            ],
                          ),
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
