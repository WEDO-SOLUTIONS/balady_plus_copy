import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/general_items_dialog.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';

class Generalinfowidget extends StatelessWidget {
  const Generalinfowidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: const Color(0xFF568F64),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            // image: const DecorationImage(
            //   image: AssetImage(
            //       'packages/smart_advisor/smart_advisor_assets/images/detailesBackG.png'), // Path to your image
            //   fit: BoxFit.cover, // Fit the image to cover the entire container
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "نشاطك الأساسي",
                style: AppStyle.textRegularStyle.copyWith(
                  fontSize: 12,
                  color: AppColor.white.withOpacity(0.67),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                context.read<DetailsBloc>().args.activityId?.name ?? "",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(fontSize: 14, color: AppColor.white),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.read<DetailsBloc>().args.addetionalActivites !=
                      null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "الانشطه الاضافية",
                          style: AppStyle.textRegularStyle.copyWith(
                            fontSize: 12,
                            color: AppColor.white.withOpacity(0.67),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: const Color(0xff000000),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext ctx) => GeneralItemsDialog(
                                title: "الانشطه الاضافية",
                                items: context
                                        .read<DetailsBloc>()
                                        .args
                                        .addetionalActivites
                                        ?.where((r) => r.isSelected == true)
                                        ?.map((e) => e.activityName)
                                        .nonNulls
                                        .toList() ??
                                    [],
                              ),
                            );
                          },
                          child: Text(
                            "لديك ${context.read<DetailsBloc>().args.addetionalActivites?.where((r) => r.isSelected == true).length ?? 0} أنشطة",
                            style: AppStyle.textRegularRomanStyle.copyWith(
                              fontSize: 14,
                              color: AppColor.white,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Colors.white, // Color of the underline
                              decorationThickness: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (context.read<DetailsBloc>().args.permits != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "التصاريح ",
                          style: AppStyle.textRegularStyle.copyWith(
                            fontSize: 12,
                            color: AppColor.white.withOpacity(0.67),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: const Color(0xff000000),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext ctx) => GeneralItemsDialog(
                                title: "التصاريح",
                                items: context
                                        .read<DetailsBloc>()
                                        .args
                                        .permits
                                        ?.where((r) => r.isSelected == true)
                                        ?.map((e) => e.name)
                                        .nonNulls
                                        .toList() ??
                                    [],
                              ),
                            );
                          },
                          child: Text(
                            "لديك ${context.read<DetailsBloc>().args.permits?.where((r) => r.isSelected == true).length ?? 0} تصريح",
                            style: AppStyle.textRegularRomanStyle.copyWith(
                              fontSize: 14, color: AppColor.white,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Colors.white, // Color of the underline
                              decorationThickness: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.10),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.white.withOpacity(0.12),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                            child: SvgPicture.asset(
                              IconPath.location1Icon,
                              color: AppColor.white,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "الحي",
                                      style: AppStyle.textRegularRomanStyle
                                          .copyWith(
                                              color: AppColor.white
                                                  .withOpacity(0.67),
                                              fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${context.read<DetailsBloc>().args.gisData?.districtName ?? ""}",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(
                                          color: AppColor.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        height: 10, thickness: 1, color: AppColor.white),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColor.white.withOpacity(0.10),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                              ),
                              child: SvgPicture.asset(
                                IconPath.area1Icon,
                                color: AppColor.white,
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "المساحة",
                                      style: AppStyle.textRegularRomanStyle
                                          .copyWith(
                                              color: AppColor.white
                                                  .withOpacity(0.67),
                                              fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${context.read<DetailsBloc>().args.suggestedArea?.getItem() ?? ""}",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(
                                          color: AppColor.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
