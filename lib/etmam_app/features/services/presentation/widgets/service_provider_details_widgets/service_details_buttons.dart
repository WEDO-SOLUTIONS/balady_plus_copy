import 'package:balady_plus/etmam_app/core/utils/common_properties.dart'
    show CommonProperties;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AuthStatus, CommonFunctions;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show NeedLoginWidget, ProviderButtons, showPopUpWidget;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        GetRelationsForDetailsEvent,
        RelationParams,
        ServiceDetailsBloc,
        ServiceDetailsState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailsButton extends StatelessWidget {
  const ServiceDetailsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: ProviderButtons(onCallPressed: () {
            CommonFunctions.call(state.response.provider?.mainBranchContact);
          }, onDelegatePress: () {
            if (!CommonProperties.isUserLogged) {
              showPopUpWidget(context,
                  popUpBody: NeedLoginWidget(
                    withMargin: false,
                    onSuccessLogin: (bool? isSuccess) {
                      if (isSuccess == true) {
                        Navigator.of(context).pop();

                        context.read<ServiceDetailsBloc>().add(
                            GetRelationsForDetailsEvent(
                                params: RelationParams(
                                    serviceProviderId:
                                        state.response.provider?.id ?? "",
                                    serviceProviderName:
                                        state.response.provider?.name ?? "",
                                    cityId: CommonProperties.cityId,
                                    subServiceId: state.subServiceId!)));
                      }
                    },
                  ));
            } else {
              context.read<ServiceDetailsBloc>().add(
                  GetRelationsForDetailsEvent(
                      params: RelationParams(
                          serviceProviderId: state.response.provider?.id ?? "",
                          serviceProviderName:
                              state.response.provider?.name ?? "",
                          cityId: CommonProperties.cityId,
                          subServiceId: state.subServiceId!)));
            }
          }),
        );
      },
    );
  }
}
