import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/card_cost_info_widget.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/card_desc_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/button_in_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';



class ApprovalSequenceShopLocationScreen extends StatefulWidget {
  final void Function() goToNewPage;
  const ApprovalSequenceShopLocationScreen({Key? key, required this.goToNewPage}) : super(key: key);

  @override
  State<ApprovalSequenceShopLocationScreen> createState() => _ApprovalSequenceShopLocationScreenState();
}

class _ApprovalSequenceShopLocationScreenState extends State<ApprovalSequenceShopLocationScreen> {


  bool isAgree = false;
  List<int> lstPermits = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return getBody();

  }
  Widget getBody() {

    return
      Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HorizontalRadioGroup<CRContractOption>(
              //   groupName: "shop_location".tr(),
              //   currentItem: state.crContractOption,
              //   items: [
              //     if (state.showAttachInvest())
              //       RadioItem<CRContractOption>(
              //           radioText: "attach_invest_contract".tr(),
              //           radioValue: CRContractOption.attach),
              //     if (state.showServiceInvest())
              //       RadioItem<CRContractOption>(
              //           radioText: "user_attach_invest_contract".tr(),
              //           radioValue: CRContractOption.service),
              //   ],
              //   onChanged: (value) {
              //     context
              //         .read<RenewCommercialLicenseBloc>()
              //         .updateCRContractOption(value!);
              //   },
              // ),
            ],
          ),
        ),
      );


  }




}

