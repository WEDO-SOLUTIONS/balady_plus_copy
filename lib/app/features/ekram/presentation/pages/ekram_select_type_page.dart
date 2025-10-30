import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart' show trans;
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EkramSelectRequestTypePage extends StatefulWidget {
  const EkramSelectRequestTypePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EkramSelectRequestTypePage> createState() =>
      _EkramSelectRequestTypePageState();
}

class _EkramSelectRequestTypePageState
    extends State<EkramSelectRequestTypePage> {
  @override
  Widget build(BuildContext context) {
    EkramRequestsBloc ekramRequestsBloc =
        ModalRoute.of(context)!.settings.arguments as EkramRequestsBloc;

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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    Constants.whiteCloseImg,
                    height: 20.0,
                    width: 20.0,
                    color: Colors.black,
                  ),
                ),
                CustomVerticalSpace(height: 32),
                CustomTextWidget(
                  trans('ekramNewOrder'),
                  fontSize: 24,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.black,
                  textAlign: TextAlign.start,
                ),
                /*  CustomVerticalSpace(height: 12),
                CustomTextWidget(
                  trans('ekramNewOrderDesc'),
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  fontColor: AppColors.black400,
                  height: 1.4,
                  textAlign: TextAlign.start,
                ),*/
                CustomVerticalSpace(height: 20),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: EkramTypes.getEkramTypes.length,
                  itemBuilder: (ctx, index) {
                    return EkramTypeCardWidget(
                      ekramTypes: EkramTypes.getEkramTypes[index],
                      ekramBloc: ekramRequestsBloc,
                    );
                  })),
        ],
      ),
    );
  }
}
