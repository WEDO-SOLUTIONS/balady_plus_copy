import 'package:balady_new_app/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomTextWidget,
        CustomVerticalSpace,
        FONT_WEIGHT;
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';

import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart' show trans;

class EkramSelectRequestTypePage extends StatefulWidget {
  final EkramRequestsBloc ekramRequestsBloc;
  const EkramSelectRequestTypePage({Key? key, required this.ekramRequestsBloc})
      : super(key: key);

  @override
  State<EkramSelectRequestTypePage> createState() =>
      _EkramSelectRequestTypePageState();
}

class _EkramSelectRequestTypePageState
    extends State<EkramSelectRequestTypePage> {
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
                  fontWeight: FONT_WEIGHT.bold,
                  fontColor: AppColors.black,
                  textAlign: TextAlign.start,
                ),
                /*  CustomVerticalSpace(height: 12),
                CustomTextWidget(
                  trans('ekramNewOrderDesc'),
                  fontSize: 16,
                  fontWeight: FONT_WEIGHT.medium,
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
                      ekramBloc: widget.ekramRequestsBloc,
                    );
                  })),
        ],
      ),
    );
  }
}
