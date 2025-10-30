import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath, PageTypes, trans;
import '../../shared_feature_exports.dart'
    show
        CustomPrimaryButton,
        CustomSvgIconWidget,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        SuccessScreenArgs;

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    SuccessScreenArgs successScreenArgs =
        ModalRoute.of(context)!.settings.arguments as SuccessScreenArgs;

    return Scaffold(
        appBar: null,
        body: Container(
          color: AppColor.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: MediaQuery.of(context).padding.top + 10, start: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CustomSvgIconWidget(IconPath.close,
                      iconColor: AppColor.black),
                ),
              ),
              SuccessBody(
                successScreenArgs: successScreenArgs,
              ),
              SuccessButtons(
                fromHomePage: successScreenArgs.fromHomePage ?? false,
                pageType: successScreenArgs.type,
              )
            ],
          ),
        ));
  }
}

class SuccessBody extends StatelessWidget {
  final SuccessScreenArgs? successScreenArgs;

  SuccessBody({Key? key, this.successScreenArgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomSvgIconWidget(
                successScreenArgs?.icon ?? IconPath.successIcon,
                iconHeight: successScreenArgs?.iconHeight,
                iconWidth: successScreenArgs?.iconWidth,
              ),
              const CustomVerticalSpace(
                height: 26,
              ),
              CustomTextWidget(
                getTitle(),
                fontSize: 22,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black,
              ),
              const CustomVerticalSpace(
                height: 20,
              ),
              CustomTextWidget(
                successScreenArgs?.thanksMessage ?? "",
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.black500,
                textAlign: TextAlign.center,
              ),
              const CustomVerticalSpace(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTitle() {
    switch (successScreenArgs?.type) {
      case PageTypes.orderScreen:
      case PageTypes.cancelOrder:
      case PageTypes.evaluateOrder:
      case PageTypes.orderDetails:
        return trans('thank_you');
      // case PageTypes.cancelOrder:
      default:
        return trans('thank_you');
    }
  }
}

class SuccessButtons extends StatelessWidget {
  final PageTypes pageType;
  bool fromHomePage;

  SuccessButtons({Key? key, required this.pageType, this.fromHomePage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (getBlueBtnText().isNotEmpty) ...[
              CustomPrimaryButton(
                  onPressed: () {
                    onPressBlueButton(context);
                  },
                  btnText: getBlueBtnText()),
              const CustomVerticalSpace(height: 20),
            ],
            if (getWhiteBtnText().isNotEmpty)
              CustomTextButtonWidget(
                btnPressed: () {
                  onPressWhiteButton(context);
                },
                btnText: getWhiteBtnText(),
                btnTextSize: 16,
                btnTextWeight: AppFontWeight.regular,
              )
          ],
        ),
      ),
    );
  }

  String getBlueBtnText() {
    switch (pageType) {
      case PageTypes.orderScreen:
      case PageTypes.cancelOrder:
      case PageTypes.evaluateOrder:
      case PageTypes.orderDetails:
        return trans('go_to_orders');
      default:
        return "";
    }
  }

  void onPressBlueButton(BuildContext context) {
    switch (pageType) {
      case PageTypes.orderScreen:
        {
          Navigator.of(context)
              .pushReplacementNamed(EtmamRoutesNames.myRequestsPage);
          // bottomNavigationPickItemService.pickBottomNavigationItem(1);
        }
        break;
      case PageTypes.cancelOrder:
      case PageTypes.evaluateOrder:
      case PageTypes.orderDetails:
        Navigator.of(context)
            .popUntil(ModalRoute.withName(EtmamRoutesNames.myRequestsPage));

        break;
      default:
        {}
        break;
    }
  }

  String getWhiteBtnText() {
    switch (pageType) {
      // case PageTypes.orderScreen:
      // return trans('rate_your_experience');
      default:
        return "";
    }
  }

  void onPressWhiteButton(BuildContext context) {
    switch (pageType) {
      // case PageTypes.orderScreen:
      //   {}
      //   break;
      default:
        {}
        break;
    }
  }
}
