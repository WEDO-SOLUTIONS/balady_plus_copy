import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/text_item_html_component.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_widgets/general_items_html_dialog.dart';
import '../../../../../shared_features/widgets/custom_button.dart';

class SpecialCondtion extends StatelessWidget {
  const SpecialCondtion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(builder: (ctx, state) {
      return Column(
        children: [
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    (state.regulationResponse?.specialRules.length ?? 0) > 3
                        ? 3
                        : (state.regulationResponse?.specialRules.length ?? 0),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return TextItemHtmlComponent(
                    description:
                        state.regulationResponse?.specialRules[index] ?? "",
                  );
                }),
          ),
          /*  CustomButton(
            btnColor: AppColor.surfaceAccentSecondaryColor,
            textColor: AppColor.statusAccentColor,
            onPress: () {
              showModalBottomSheet(
                backgroundColor: const Color(0xff000000),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => GeneralItemsHtmlDialog(
                    title: "specialـrequirements".tr(),
                    items: state.regulationResponse?.specialRules ?? []),
              );
            },
            text: ("all_requirements").tr(),
          ),*/
        ],
      );
    });
  }
}
