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
  final SuccessScreenArgs successScreenArgs;

  const SuccessScreen({Key? key, required this.successScreenArgs})
      : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    sendAnalytics(widget.successScreenArgs.type);
  }

  @override
  Widget build(BuildContext context) {
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
                successScreenArgs: widget.successScreenArgs,
              ),
              SuccessButtons(
                fromHomePage: widget.successScreenArgs.fromHomePage ?? false,
                pageType: widget.successScreenArgs.type,
              )
            ],
          ),
        ));
  }

  void sendAnalytics(PageTypes type) {
    try {
      switch (type) {
        case PageTypes.orderScreen:
          if (widget.successScreenArgs.changeProvider == true)
            //CommonFunctions.sendEventToAnalytics(
            //  AppEvents.SuccessChangeProvider);
            //  else
            //CommonFunctions.sendEventToAnalytics(AppEvents.SuccessNewRequest);
            break;
        case PageTypes.cancelOrder:
          //CommonFunctions.sendEventToAnalytics(AppEvents.SuccessCancelOrder);
          break;
        case PageTypes.evaluateOrder:
          //CommonFunctions.sendEventToAnalytics(AppEvents.SuccessEvaluateOrder);
          break;
        case PageTypes.orderDetails:
          //CommonFunctions.sendEventToAnalytics(AppEvents.SuccessChangeProvider);
          break;
      }
    } catch (ex) {}
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
              .pushReplacementNamed(EtmamRoutesNames.myOrdersPage);
          // bottomNavigationPickItemService.pickBottomNavigationItem(1);
        }
        break;
      case PageTypes.cancelOrder:
      case PageTypes.evaluateOrder:
      case PageTypes.orderDetails:
        Navigator.of(context)
            .popUntil(ModalRoute.withName(EtmamRoutesNames.myOrdersPage));

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
