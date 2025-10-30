import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_requests/my_requests_bloc.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/offers/offers_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomInkWellButtonWidget, CustomTextWidget;

class OffersTabsWidget extends StatefulWidget {
  const OffersTabsWidget({Key? key}) : super(key: key);

  @override
  State<OffersTabsWidget> createState() => _OffersTabsWidgetState();
}

class _OffersTabsWidgetState extends State<OffersTabsWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestOfferBloc, OffersState>(
        buildWhen: (previous, current) =>
            previous.currentRequest != current.currentRequest,
        builder: (context, state) {
          return Container(
              // decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(16)),
              //     color: AppColor.white),
              // margin: const EdgeInsets.symmetric(vertical: 16),
              //padding: const EdgeInsets.symmetric(vertical: 13),
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (state.requestReplies ?? [])
                  .asMap()
                  .map((i, tabs) => MapEntry(
                      i,
                      TabWidget(
                        btnPressed: () {
                          setState(() {
                            selectedIndex = i;
                          });
                          context
                              .read<RequestOfferBloc>()
                              .add(GetOffersEvent(request: tabs));
                        },
                        tabText: tabs.subServiceName ?? "",
                        isSelected: i == selectedIndex,
                        // isSelected: i == state.gettCurrenttTabIndex(),
                        haveSeperator:
                            (state.requestReplies ?? []).length != i + 1,
                      )))
                  .values
                  .toList(),
            ),
          ));
        });
  }
}
/*
class TabWidget extends StatelessWidget {
  final String tabText;
  bool isSelected;
  final VoidCallback? btnPressed;
  final bool haveSeperator;

  TabWidget(
      {Key? key,
      required this.tabText,
      this.isSelected = false,
      required this.btnPressed,
      this.haveSeperator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomInkWellButtonWidget(
            btnPressed: () {
              btnPressed!();
            },
            widget: Column(
              children: [
                CustomTextWidget(
                  trans(tabText),
                  fontSize: 14.0,
                  fontWeight:
                      isSelected ? AppFontWeight.medium : AppFontWeight.regular,
                  fontColor:
                      isSelected ? AppColorsTheme.primary700 : AppColor.black,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Container(
                    width: 24,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(const Radius.circular(2)),
                        color: isSelected
                            ? AppColorsTheme.primary700
                            : Colors.transparent))
              ],
            ),
          ),
        ),
        Container(
            width: 0.5,
            height: 20,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                color: haveSeperator
                    ? AppColorsTheme.primary700
                    : Colors.transparent))
      ],
    );
  }
}*/

class TabWidget extends StatelessWidget {
  final String tabText;
  bool isSelected;
  final VoidCallback? btnPressed;
  final bool haveSeperator;

  TabWidget(
      {Key? key,
      required this.tabText,
      this.isSelected = false,
      required this.btnPressed,
      this.haveSeperator = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomInkWellButtonWidget(
          btnPressed: () {
            btnPressed!();
          },
          widget: Container(
            padding: const EdgeInsets.all(8),
            // margin: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
                color: isSelected ? AppColor.primary900 : AppColor.white,
                borderRadius: BorderRadius.circular(12)),
            child: CustomTextWidget(
              trans(tabText),
              fontSize: 11.0,
              fontWeight: AppFontWeight.bold,
              // fontWeight:
              //     isSelected ? AppFontWeight.medium : AppFontWeight.regular,
              fontColor: isSelected ? AppColor.white : AppColor.primary900,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
