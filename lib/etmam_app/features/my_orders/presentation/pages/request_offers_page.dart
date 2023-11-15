import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/empty_state_widget.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_offers_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/offers/offers_bloc.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/offer_page/offer_card.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/offer_page/offers_tabs_widget.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderDetailsParams;
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';

class RequestOffersPage extends StatelessWidget {
  const RequestOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    RequestOffersPageParams params =
        ModalRoute.of(context)!.settings.arguments as RequestOffersPageParams;

    return Scaffold(
        appBar: CustomAppBar(
          title: trans('replies_on_request'),
          withBackImg: true,
        ),
        body: BlocProvider(
          create: (context) => RequestOfferBloc(
              getOffers: sl(),
              acceptOffer: sl(),
              rejectOffer: sl(),
              getProviderDetails: sl(),
              args: params),
          child: BlocConsumer<RequestOfferBloc, OffersState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          OffersTabsWidget(),
                          CustomVerticalSpace(height: 50),
                          /*if (state.request?.isAccepted ?? false)
                            EmptyStateWidget(
                              img: IconPath.emptyServicesLogo,
                              title: trans('offer_aceepted'),
                            ),*/
                          if ((state.items?.isEmpty ?? false))
                            EmptyStateWidget(
                              img: IconPath.emptyServicesLogo,
                              title: trans('no_offers'),
                            ),
                          if (state.status != BlocStatus.retry)
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.items?.length ?? 0,
                                itemBuilder: (ctx, index) {
                                  Action? accept =
                                      state.items?[index].getAccept;
                                  Action? reject =
                                      state.items?[index].getReject;
                                  return OfferCard(
                                    onPress: () {
                                      context.read<RequestOfferBloc>().add(
                                          GetPRoviderDetailsEvent(
                                              params: ProviderDetailsParams(
                                                  cityId:
                                                      CommonProperties.cityId,
                                                  providerId: state
                                                      .items![index]
                                                      .providerId!)));
                                    },
                                    rating: state.items?[index].rating,
                                    providerName:
                                        state.items?[index].providerName ?? "",
                                    providerIcon:
                                        state.items?[index].providerLogo,
                                    onAcceptPressed: () {
                                      context.read<RequestOfferBloc>().add(
                                          AcceptOfferEvent(
                                              id: state.items?[index].id));
                                    },
                                    technicalAttachmentId: state
                                        .items?[index].technicalAttachmentId,
                                    financialAttachmentId: state
                                        .items?[index].financialAttachmentId,
                                    onCancelPressed: () {
                                      context.read<RequestOfferBloc>().add(
                                          RejectOfferEvent(
                                              id: state.items?[index].id));
                                    },
                                    isOfferAccepted:
                                        state.items?[index].status?.id ==
                                            "accepted",
                                    acceptTxt: accept?.name,
                                    showAccept: accept != null,
                                    cancelTxt: reject?.name,
                                    showCancel: reject != null,
                                    notes: state.items?[index].notes,
                                    value: state.items?[index].value.toString(),
                                  );
                                }),
                          if (state.status == BlocStatus.retry)
                            ReloadWidget(
                              onTab: () {
                                context
                                    .read<RequestOfferBloc>()
                                    .add(GetOffersEvent());
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomLoadingWidget(),
                ],
              );
            },
          ),
        ));
  }
}
