import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/models/addtionalInfoModel.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/custom_divider.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/language.dart';
import 'approvals_widget.dart';

class DetailsItemWidget extends StatelessWidget {
  DetailsItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) =>
          previous.entityActivityDetailsStatus !=
          current.entityActivityDetailsStatus,
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(top: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              /*DetailsItem(
                  title: "about".tr(),
                  subTitle: state.entityActivityDetailsResponse?.about ?? "",
                ),*/
              children: [
                DetailsItem(
                  title: "about".tr(),
                  subTitle: state.entityActivityDetailsResponse?.about ?? "",
                ),
                /*
                DetailsItem(
                  title: "sector".tr(),
                  subTitle:
                      state.entityActivityDetailsResponse?.sector?.name ?? "",
                ),*/
                DetailsItem(
                  title: "isicActivity".tr(),
                  subTitle: state.entityActivityDetailsResponse?.isicName
                          .toString() ??
                      "",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailsItem(
                        title: "totalActiveLicense".tr(),
                        subTitle: state.entityActivityDetailsResponse
                                ?.totalActiveLicense
                                .toString() ??
                            "",
                      ),
                      DetailsItem(
                          subTitle: state
                                  .entityActivityDetailsResponse?.isicCode
                                  .toString() ??
                              "",
                          title: 'النشاط'),
                    ],
                  ),
                ),

                /*DetailsItem(
                  title: "about".tr(),
                  subTitle: state.entityActivityDetailsResponse?.about ?? "",
                ),*/
                DetailsItem(
                  title: "isFawery".tr(),
                  subTitle:
                      state.entityActivityDetailsResponse?.baladyWorkFlow ==
                              "IMMEDIATE"
                          ? "yes".tr()
                          : "no".tr(),
                  showDivider: false,
                ),
                const CustomDivider(),
              ],
            ));
      },
    );
  }
}

class DetailsItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool showDivider;
  const DetailsItem(
      {super.key,
      required this.subTitle,
      required this.title,
      this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 14, left: 14, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: AppStyle.footNoteMediumStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            subTitle,
            style: AppStyle.footNoteMediumStyle
                .copyWith(color: AppColor.textSecondaryColor, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          if (showDivider)
            Divider(
              color: Color(0xffF5F5F5),
              height: 1,
              thickness: 1,
            ),
        ],
      ),
    );
  }
}
