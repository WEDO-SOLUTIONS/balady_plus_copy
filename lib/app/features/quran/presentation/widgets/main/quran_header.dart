import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class QuranHeader extends StatelessWidget {
  final int jozz;
  final String suraName;
  const QuranHeader({super.key, required this.jozz, required this.suraName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: state.showDetails == true ? 30.0 : 0.0,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff036362),
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
            )
          ]),
        );
      },
    );
  }
}
