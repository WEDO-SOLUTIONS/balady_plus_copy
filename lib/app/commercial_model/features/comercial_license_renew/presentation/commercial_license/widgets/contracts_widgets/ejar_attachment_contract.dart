import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/submit_renew_commercial_bloc/renew_commercial_license_bloc.dart';

class AttachContract extends StatelessWidget {
  const AttachContract({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return (state.showDeedAttach() ||
                    state.showINVESTAttach() ||
                    state.showEJARAttach()) &&
                state.info?.ownershipResponseDto?.contractDownloadUrl != null &&
                state
                    .info!.ownershipResponseDto!.contractDownloadUrl!.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  CommonFunctions.showApigeeFile(
                      state.info?.ownershipResponseDto?.contractDownloadUrl ??
                          "",
                      state.info?.ownershipResponseDto?.contractNumber ??
                          DateTime.now().millisecond.toString());
                },
                child: Container(
                  height: 85,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(IconPath.vdSummuryDesc),
                              const SizedBox(
                                width: 8,
                              ),
                              CustomTextWidget(
                                "attached_contract".tr(),
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 16,
                                maxLines: 2,
                                fontWeight: AppFontWeight.bold,
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextWidget(
                              state.getContractName(),
                              fontColor: AppColor.primary900Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Expanded(
                            child: CustomSvgIconWidget(
                              IconPath.receiveSquare,
                              iconSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
