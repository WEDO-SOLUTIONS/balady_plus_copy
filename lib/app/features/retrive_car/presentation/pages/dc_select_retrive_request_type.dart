import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/dc_types.dart';
import '../widgets/retrive_type_card_widget.dart';

class DCSelectRetrieveTypePage extends StatefulWidget {
  const DCSelectRetrieveTypePage({Key? key}) : super(key: key);

  @override
  State<DCSelectRetrieveTypePage> createState() =>
      _DCSelectRetrieveTypePageState();
}

class _DCSelectRetrieveTypePageState extends State<DCSelectRetrieveTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                right: 16,
                left: 16,
                top: MediaQuery.of(context).padding.top + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogHeader(
                  title: ('dc_center').tr(),
                ),
                CustomVerticalSpace(height: 20),
              ],
            ),
          ),
          Expanded(
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      bottom: Constants.mediumPadding,
                      left: Constants.semiMediumPadding,
                      right: Constants.semiMediumPadding,
                      top: Constants.smallPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 19.0,
                    mainAxisSpacing: 18.0,
                  ),
                  itemCount: DCTypes.getRetriveTypes.length,
                  itemBuilder: (ctx, index) {
                    return RetriveTypeCardWidget(
                      dcTypes: DCTypes.getRetriveTypes[index],
                    );
                  })),
        ],
      ),
    );
  }
}
