import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/wallet/core/blocs/wallet/wallet_bloc.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../core/models/wallet_type.dart';
import '../../wallet_exports.dart';
import 'package:collection/collection.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.wallet);
    CommonFunctions.sendUXCamEvent(UXCamEvents.openWallet);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => WalletBloc(),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
                title: "bottomNavigationBarDigitalWalletWord".tr()),
            body: Stack(
              children: [
                if (state.status == BlocStatus.success &&
                    state.getItems().length > 0)
                  const WalletFooter(),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RoundedCard(
                            title: 'all'.tr(),
                            iconPath: IconPath.sliderVertical,
                            isSelected: state.selectedTypeIndex == 0,
                            onTap: () => context
                                .read<WalletBloc>()
                                .add(ChangeTypeEvent(index: 0)),
                          ),
                          ...wallerTypesData
                              .mapIndexed((index, e) => RoundedCard(
                                    title: e.title.tr(),
                                    iconPath: e.icon,
                                    isSelected:
                                        state.selectedTypeIndex == index + 1,
                                    onTap: () => context
                                        .read<WalletBloc>()
                                        .add(ChangeTypeEvent(index: index + 1)),
                                  ))
                              .toList(),
                        ],
                      ),
                      if (state.status == BlocStatus.loading)
                        CustomCircularLoadingWidget(),
                      if (state.status == BlocStatus.success &&
                          state.getItems().length == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: EmptyListWidget(
                            title: "noDataToDisplay".tr(),
                          ),
                        ),
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          if ((state.status == BlocStatus.success &&
                                  state.getItems().length > 0) ||
                              state.status == BlocStatus.loading) {
                            return (state.showAll ?? false) &&
                                    (state.status == BlocStatus.success &&
                                        state.getItems().length > 0)
                                ? Flexible(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.only(top: 24),
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemCount:
                                          (state.getItems().length ?? 0) > 5
                                              ? 5
                                              : (state.getItems().length ?? 0),
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) =>
                                          BusinessLicenseCard(
                                        bgImagePath: state
                                            .getItems()[index]
                                            .getLicenseImage(),
                                        title: state
                                                .getItems()[index]
                                                .getLicenseHeaderText() ??
                                            "",
                                        cardNumber:
                                            state.getItems()[index].licenseId ??
                                                "",
                                        expireDate: state
                                                .getItems()[index]
                                                .endDateHijri ??
                                            "",
                                        creationDate: state
                                                .items?[index].startDateHijri ??
                                            "",
                                        holderName:
                                            state.getItems()[index].getName(),
                                        onPressed: () => context.pushNamedRoute(
                                            RouteName.businessLicensePage,
                                            arguments: state.getItems()[index]),
                                      ),
                                    ),
                                  )
                                : (state.showAll == false) &&
                                        (state.status == BlocStatus.success &&
                                            state.getItems().length > 0)
                                    ? Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: state.getItems().length < 3
                                                ? MediaQuery.sizeOf(context)
                                                        .height /
                                                    10
                                                : MediaQuery.sizeOf(context)
                                                        .height /
                                                    4,
                                          ),
                                          child: CardSwiper(
                                            isDisabled: true,
                                            cardsCount:
                                                (state.getItems().length ?? 0) >
                                                        5
                                                    ? 5
                                                    : (state
                                                            .getItems()
                                                            .length ??
                                                        0),
                                            numberOfCardsDisplayed:
                                                (state.getItems().length ?? 0) >
                                                        5
                                                    ? 5
                                                    : (state
                                                            .getItems()
                                                            .length ??
                                                        0),
                                            duration: const Duration(
                                                milliseconds: 400),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            backCardOffset:
                                                const Offset(0, -50),
                                            cardBuilder: (_, index, __, ___) =>
                                                BusinessLicenseCard(
                                              bgImagePath: state
                                                  .getItems()[index]
                                                  .getLicenseImage(),
                                              title: state
                                                      .getItems()[index]
                                                      .getLicenseHeaderText() ??
                                                  "",
                                              cardNumber: state
                                                      .getItems()[index]
                                                      .licenseId
                                                      .toString() ??
                                                  "",
                                              expireDate: state.items?[index]
                                                      .endDateHijri ??
                                                  "",
                                              creationDate: state
                                                      .getItems()[index]
                                                      .startDateHijri ??
                                                  "",
                                              holderName: state
                                                      .getItems()[index]
                                                      .getName() ??
                                                  "",
                                              onPressed: () => context
                                                  .read<WalletBloc>()
                                                  .add(
                                                      const ChangeViewAllEvent()),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                          }

                          return Container();
                        },
                      ),
                      if (state.status == BlocStatus.failure ||
                          state.status == BlocStatus.retry)
                        ReloadWidget(onTab: () {
                          context.read<WalletBloc>().add(GetWalletDataEvent());
                        })
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
