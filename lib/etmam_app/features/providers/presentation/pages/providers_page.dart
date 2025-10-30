import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show SearchTextFieldWidget;
import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, trans, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomAppBar,
        CustomLoadingWidget,
        CustomShimmerListWidget,
        EmptyStateWidget;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../_shared_feature_/shared/presentation/widgets/custom_appbar_providers.dart';

class ProvidersPage extends StatefulWidget {
  //final ProviderResponse providerResponse;
  const ProvidersPage({
    Key? key,
    //required this.providerResponse,
  }) : super(key: key);

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  final ScrollController _scrollController = new ScrollController();
  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ProvidersListPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProvidersBloc(
        getProvider: sl(),
        getProviderDetails: sl(),
        scrollController: _scrollController,
        // response: widget.providerResponse
      ),
      child: BlocConsumer<ProvidersBloc, ProviderState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(180 - MediaQuery.of(context).padding.top),
              child: CustomAppBarProvidersList(
                title: trans("service_providers"),
                bottomWidget: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: SearchTextFieldWidget(
                    hintText: "search".tr(),
                    containerHeight: 50,
                    onTextChanged: (String? text) {
                      if (text != state.name) {
                        _debouncer.run(
                          () {
                            context.read<ProvidersBloc>().add(
                                  GetTopProvidersEvent(
                                    params: TopRatedProviderParams(
                                        cityId: CommonProperties.cityId,
                                        pageSize: "10",
                                        name: text,
                                        pageIndex: "1"),
                                  ),
                                );
                          },
                        );
                      }
                    },
                    onSubmitSearch: () {},
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    const CustomVerticalSpace(height: 8),
                    Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 4,
                              ),
                          controller: _scrollController,
                          itemCount: (state.items?.length ?? 0) + 1,
                          itemBuilder: (ctx, index) {
                            if (index >= (state.items?.length ?? 0)) {
                              if (state.status == BlocStatus.loadMore) {
                                return const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: CustomLoadingWidget(),
                                  ),
                                );
                              } else {
                                return Container(height: 50);
                              }
                            }

                            return ProviderItemWidget(
                              providerTotalEvaluation:
                                  state.items![index].totalEvaluationNumber,
                              providerRating: state.items![index].ratingAverage,
                              providerName:
                                  state.items![index].serviceProviderName,
                              providerIcon: state.items![index].logoImageUrl,
                              contact: state.items![index].contact,
                              onPressView: () {
                                context.read<ProvidersBloc>().add(
                                    GetPRoviderDetailsEvent(
                                        params: ProviderDetailsParams(
                                            cityId: CommonProperties.cityId,
                                            providerId:
                                                state.items![index].id!)));
                              },
                            );
                          }),
                    ),
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const CustomLoadingWidget(),
                if (state.status == BlocStatus.loadingShimmer)
                  const CustomShimmerListWidget(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    height: 90,
                    itemCount: 10,
                  ),
                if (state.items?.isEmpty ??
                    true && state.status == BlocStatus.success)
                  Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 24),
                      child: EmptyStateWidget(
                        img: IconPath.emptyServicesLogo,
                        title: trans('no_result'),
                        desc: "",
                      ))
              ],
            ),
          );
        },
      ),
    );
  }
}
