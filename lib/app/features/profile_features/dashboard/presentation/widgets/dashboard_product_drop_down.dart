import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, BlocRequestStatus, CommonFunctions, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../dashboard_exports.dart'
    show
        DashboardBloc,
        DashboardCardEntity,
        DashboardOnProductSelected,
        DashboardOnProductsPressed,
        DashboardState;

class DashboardProductDropDown extends StatelessWidget {
  final DashboardCardEntity card;

  const DashboardProductDropDown({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) =>
          previous.cardsStates[card]?.productsStatus !=
          current.cardsStates[card]?.productsStatus,
      listener: (context, state) {
        final status = state.cardsStates[card]?.productsStatus;
        if (status == BlocRequestStatus.submissionGetSuccess) {
          final products = state.cardsStates[card]?.products;
          if (products?.isNotEmpty ?? false) {
            showProducts(context: context, state: state);
          }
        }
      },
      buildWhen: (previous, current) =>
          previous.cardsStates[card]?.productsStatus !=
              current.cardsStates[card]?.productsStatus ||
          previous.cardsStates[card]?.selectedProduct !=
              current.cardsStates[card]?.selectedProduct,
      builder: (context, state) {
        final products = state.cardsStates[card]?.products;
        final status = state.cardsStates[card]?.productsStatus;
        final selectedProduct = state.cardsStates[card]?.selectedProduct;
        return InkWell(
          onTap: () {
            if (status == BlocRequestStatus.submissionGetLoading) return;
            if (products?.isEmpty ?? true) {
              BlocProvider.of<DashboardBloc>(context)
                  .add(DashboardOnProductsPressed(card: card));
            } else {
              showProducts(context: context, state: state);
            }
          },
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  status == BlocRequestStatus.submissionGetLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primary900Light,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Flexible(
                          child: AutoSizeText(
                            selectedProduct?.name ?? "all".tr(),
                            style: const TextStyle(
                                color: AppColor.primary900Light,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.0),
                            textAlign: TextAlign.right,
                            minFontSize: 9,
                            maxLines: 2,
                          ),
                        ),
                  const CustomHorizontalSpace(width: 4),
                  SvgPicture.asset(IconPath.iosArrowDown)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showProducts({
    required BuildContext context,
    required DashboardState state,
  }) async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.DashBoard_Click_Dashboard_Filter_Event);
    final items =
        state.cardsStates[card]?.products.map((e) => e.name).toList() ?? [];
    items.insert(0, "all".tr());

    BottomSheetDialog.showDraggableSheet(
      context,
      dialogKeyName: DialogName.dashboardSelectProductDialog,
      currentRouteName: RouteName.dashboard,
      child: BottomSheetList(
        title: "product".tr(),
        items: items,
        selectedValue: state.cardsStates[card]?.selectedProduct?.name,
        onTap: (item) {
          Navigator.of(context).pop();
          BlocProvider.of<DashboardBloc>(context).add(
            DashboardOnProductSelected(
              card: card,
              product: item == "all".tr()
                  ? null
                  : state.cardsStates[card]?.products
                      .firstWhere((element) => element.name == item),
            ),
          );
        },
      ),
    );
  }
}
