/*import 'package:balady_new_app/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomTextButtonWidget,
        CustomTextWidget,
        FONT_WEIGHT,
        Helpers,
        NeedLoginWidget,
        RoutesNames,
        defaultConfiguration;
import 'package:balady_new_app/app/core/shared_local_services/common.dart';
import 'package:flutter/material.dart';

import '../../customer_voice_exports.dart' show CustomerVoiceReportTypeModel;
import 'package:balady_new_app/shared/core/services/services_exports.dart'
    show NavigationService;

class NewRequestTypeDialog extends StatefulWidget {
  const NewRequestTypeDialog({Key? key}) : super(key: key);

  @override
  State<NewRequestTypeDialog> createState() => _NewRequestTypeDialog();
}

class _NewRequestTypeDialog extends State<NewRequestTypeDialog> {
  late List<CustomerVoiceReportTypeModel> _list;

  @override
  void initState() {
    super.initState();
    _list = CustomerVoiceReportTypeModel.getListOfReportTypesFromListOfJsons(
      defaultConfiguration["RequestServiceTypes"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // button, title,
        Padding(
          padding: const EdgeInsets.only(
            top: Constants.semiMediumPadding,
            left: Constants.semiMediumPadding,
            right: Constants.semiMediumPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // close button
              CustomTextButtonWidget(
                btnPressed: () => Navigator.of(context).pop(),
                btnText: Helpers.translatingWord(
                  "customerVoiceBackButtonWord",
                ),
                btnTextColor: AppColors.grey1000,
                btnTextSize: 17.0,
                btnTextWeight: FONT_WEIGHT.medium,
              ),
              Constants.verticalSpaceMedium,
              // title
              CustomTextWidget(
                Helpers.translatingWord("lbl_choose_order_type"),
                fontColor: AppColors.black,
                fontSize: 24.0,
              ),
              Constants.verticalSpaceSmall,
            ],
          ),
        ),
        // types
        Expanded(
          child: (!isLoggedIn)
              ? NeedLoginWidget(
                  onSuccessLogin: (bool isSuccess) async {
                    setState(() {});
                  },
                )
              : GridView.builder(
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
                  itemCount: _list.length,
                  itemBuilder: (context, index) =>
                      requestServiceTypeWidget(_list[index]),
                ),
        )
      ],
    );
  }
}

class requestServiceTypeWidget extends StatelessWidget {
  CustomerVoiceReportTypeModel msrTypesModel;

  requestServiceTypeWidget(this.msrTypesModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.navigatorKey.currentState!.pushNamed(
          RoutesNames.newRequestLocationRoute,
          arguments: msrTypesModel),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
                color: AppColors.black200, width: 0.5775000000000001),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1a000000),
                  offset: Offset(0, 1),
                  blurRadius: 15,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        padding: const EdgeInsets.all(Constants.semiMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            Image.asset(
              Constants.imgPath + msrTypesModel.reportTypeIcon,
              height: 50,
              width: 50,
            ),
            Constants.verticalSpaceSmall,
            // service name
            CustomTextWidget(
              Helpers.translatingWord(msrTypesModel.reportTypeTitle),
              fontColor: AppColors.black,
              fontSize: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
*/