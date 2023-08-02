import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../services/services_exports.dart'
    show ServicesCubit, ServicesState;
import '../../../home_exports.dart' show HomeSection;

class NewServices extends StatelessWidget {
  const NewServices({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "newServices".tr(),
      topPadding: 16,
      child: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: SizedBox(
              height: 194,
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                scrollDirection: Axis.horizontal,
                itemCount: state.newServices.length,
                itemBuilder: (_, index) => Stack(
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                          top: 12, bottom: 4, end: 6, start: 6),
                      width: MediaQuery.sizeOf(context).width / 2.2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColor.blackModern900Light.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.iceBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomTextWidget(
                              state.newServices[index].tag ?? 'نص تجريبي',
                              textStyle: AppStyle.tagStyle.copyWith(
                                color: AppColor.blackModern700Light,
                                fontWeight: FontWeight.w700,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextWidget(
                            state.newServices[index].title,
                            fontColor: AppColor.blackModern800Light,
                            fontWeight: AppFontWeight.bold,
                            fontSize: 14,
                          ),
                          const SizedBox(height: 6),
                          CustomTextWidget(
                            state.newServices[index].description ?? '',
                            fontColor: AppColor.blackModern400Light,
                            fontWeight: AppFontWeight.medium,
                            maxLines: null,
                            fontSize: 12,
                          ),
                          const SizedBox(height: 16),
                          CustomElevatedButtonWidget(
                            btnColor: AppColor.primary900Light,
                            textStyle: AppStyle.elevatedButtonStyle.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            btnHeight: 40,
                            btnPadding: const EdgeInsets.all(11),
                            text: "احجز موعد",
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    PositionedDirectional(
                      end: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.scaffoldBackground,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index.isOdd
                                  ? AppColor.brown
                                  : AppColor.secondary400Light),
                          child: CustomSvgIconWidget(
                            index.isOdd
                                ? IconPath.calendarIcon
                                : IconPath.warningIcon,
                            iconSize: 24,
                            iconColor: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          // return Column(
          //   children: List.generate(state.newServices.length, (index) {
          //     return ServiceCard(
          //       service: state.newServices[index],
          //       fullWidth: true,
          //     );
          //   }),
          // );
        },
      ),
    );
  }
}
