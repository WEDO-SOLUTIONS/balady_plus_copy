import 'package:balady_plus/app/features/wallet/core/blocs/wallet/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../core/models/wallet_type.dart';
import '../../wallet_exports.dart';
import 'package:collection/collection.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => WalletBloc(),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(title: "wallet".tr()),
            body: Stack(
              children: [
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
                                    title: e.title,
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
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          if (state.status == BlocStatus.success &&
                              state.getItems().length > 0)
                            return state.showAll ?? false
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
                                        bgImagePath:
                                            "${ImagePath.visaBg}${index + 1}.png",
                                        title: state
                                                .getItems()?[index]
                                                .getLicenseHeaderText() ??
                                            "",
                                        cardNumber: state
                                                .getItems()?[index]
                                                .licenseId ??
                                            "",
                                        expireDate: state
                                                .getItems()?[index]
                                                .endDateHijri ??
                                            "",
                                        creationDate: state
                                                .items?[index].startDateHijri ??
                                            "",
                                        holderName: state
                                                .getItems()?[index]
                                                .getName() ??
                                            "",
                                        onPressed: () => context.pushNamedRoute(
                                            RouteName.businessLicensePage,
                                            arguments: state.getItems()[index]),
                                      ),
                                    ),
                                  )
                                : Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 186),
                                      child: CardSwiper(
                                        cardsCount:
                                            (state.getItems().length ?? 0) > 5
                                                ? 5
                                                : (state.getItems().length ??
                                                    0),
                                        numberOfCardsDisplayed:
                                            (state.getItems().length ?? 0) > 5
                                                ? 5
                                                : (state.getItems().length ??
                                                    0),
                                        duration:
                                            const Duration(milliseconds: 400),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        backCardOffset: const Offset(0, -50),
                                        cardBuilder: (_, index, __, ___) =>
                                            BusinessLicenseCard(
                                          bgImagePath:
                                              "${ImagePath.visaBg}${index + 1}.png",
                                          title: state
                                                  .getItems()?[index]
                                                  .getLicenseHeaderText() ??
                                              "",
                                          cardNumber: state
                                                  .getItems()?[index]
                                                  .licenseId ??
                                              "",
                                          expireDate: state
                                                  .items?[index].endDateHijri ??
                                              "",
                                          creationDate: state
                                                  .getItems()?[index]
                                                  .startDateHijri ??
                                              "",
                                          holderName: state
                                                  .getItems()?[index]
                                                  .getName() ??
                                              "",
                                          onPressed: () => context
                                              .read<WalletBloc>()
                                              .add(const ChangeViewAllEvent()),
                                        ),
                                      ),
                                    ),
                                  );

                          if (state.status == BlocStatus.loading)
                            return Container();

                          return Container();
                        },
                      ),
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
