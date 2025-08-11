import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';

class QuranHeader extends StatelessWidget {
  final int jozz;
  final String suraName;
  final int pageNumber;
  const QuranHeader(
      {super.key,
      required this.jozz,
      required this.suraName,
      required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: state.showDetails == true ? 30.0 : 0.0,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.primary900Light,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomTextWidget(
              ("الجزء ${jozz} ").tr(),
              fontColor: AppColor.primary200Light,
              fontSize: 14,
              fontWeight: AppFontWeight.semiBold,
            ),
            CustomTextWidget(
              suraName,
              fontColor: AppColor.primary200Light,
              fontSize: 14,
              fontWeight: AppFontWeight.semiBold,
            ),
            CustomTextWidget(
              (pageNumber + 1).toString(),
              fontColor: AppColor.white,
              fontSize: 14,
              fontWeight: AppFontWeight.semiBold,
            ),
          ]),
        );
      },
    );
  }
}
