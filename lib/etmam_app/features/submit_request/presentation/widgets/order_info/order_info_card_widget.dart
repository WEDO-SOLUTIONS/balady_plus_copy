import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, PrimaryIcons, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, SectionTitleWidget;

class ProviderOfficeWidget extends StatelessWidget {
  final String? providerServiceName;
  final String? subServiceName;

  const ProviderOfficeWidget(
      {Key? key, this.providerServiceName, this.subServiceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleWidget(
          title: trans('order_info_provider_office'),
          // desc: trans('order_info_provider_office_desc'),
          primaryIcon: PrimaryIcons.providerOfficeIcon,
        ),
        EtmamCustomReadOnlyTextWidget(
            label: trans('order_info_office_name'),
            text: providerServiceName ?? ""),
        EtmamCustomReadOnlyTextWidget(
            label: trans('order_info_service'), text: subServiceName ?? ""),
        CustomVerticalSpace(height: 30)
      ],
    );
  }
}

class PersonalInfoWidget extends StatelessWidget {
  const PersonalInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EtmamEntryPointCubit, EtmamEntryPointState>(
      builder: (context, state) {
        return Column(
          children: [
            SectionTitleWidget(
              title: trans('order_info_personal_info'),
              //  desc: trans('order_info_personal_info_desc'),
              primaryIcon: PrimaryIcons.personalInfoIcon,
            ),
            EtmamCustomReadOnlyTextWidget(
                label: trans('order_info_full_name'),
                text: state.profile?.nameAr ?? ""),
            EtmamCustomReadOnlyTextWidget(
                label: trans('order_info_mobile_number'),
                text: state.profile?.mobile ?? ""),
            CustomVerticalSpace(height: 30)
          ],
        );
      },
    );
  }
}

class ServiceDetailsWidget extends StatelessWidget {
  final String? serviceName;
  final String? providerName;
  final double? providerRating;
  final double? providerEvaluation;
  final String? providerIconUrl;
  final Function onDelete;
  final bool showDelete;

  const ServiceDetailsWidget(
      {Key? key,
      this.serviceName,
      this.providerEvaluation,
      this.providerName,
      this.providerRating,
      this.providerIconUrl,
      this.showDelete = false,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return serviceName != null
        ? OrderTitleAndDescWidget(
            spaceBetweenTitleAndDesc: 8,
            title: serviceName ?? "",
            descWidget: DeleteProviderWidget(
              providerEvaluation: providerEvaluation,
              providerName: providerName,
              providerRating: providerRating,
              providerLogoUrl: providerIconUrl,
              onDelete: onDelete,
              showDelete: showDelete,
            ),
          )
        : Container();
  }
}

class WhiteCardWidget extends StatelessWidget {
  final Widget child;

  const WhiteCardWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
/*        decoration: const BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-2, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
        ),*/
        child: child);
  }
}
