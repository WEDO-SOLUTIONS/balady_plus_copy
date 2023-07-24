import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../wallet_exports.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletCubit>(
      create: (context) => WalletCubit(),
      child: Scaffold(
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
                        isSelected: true,
                      ),
                      const SizedBox(width: 12),
                      RoundedCard(
                        title: "theBusinessLicense".tr(),
                        iconPath: IconPath.card,
                        isSelected: false,
                      ),
                      const SizedBox(width: 12),
                      RoundedCard(
                        title: "healthCertificates".tr(),
                        iconPath: IconPath.personalCard,
                        isSelected: false,
                      ),
                    ],
                  ),
                  BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, state) {
                      return state.viewAll
                          ? Flexible(
                              child: ListView.separated(
                                padding: const EdgeInsets.only(top: 24),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemCount: 5,
                                shrinkWrap: true,
                                itemBuilder: (_, index) => BusinessLicenseCard(
                                  bgImagePath:
                                      "${ImagePath.visaBg}${index + 1}.png",
                                  title: "businessLicense".tr(),
                                  cardNumber: '1183  1183  4289 8869',
                                  expireDate: '05/40',
                                  creationDate: '1441/10/09',
                                  holderName: 'ابراهيم اسامه احمد',
                                  onPressed: () => context.pushNamedRoute(
                                      RouteName.businessLicensePage),
                                ),
                              ),
                            )
                          : Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 186),
                                child: CardSwiper(
                                  cardsCount: 5,
                                  numberOfCardsDisplayed: 5,
                                  duration: const Duration(milliseconds: 400),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  backCardOffset: const Offset(0, -50),
                                  cardBuilder: (_, index, __, ___) => BusinessLicenseCard(
                                    bgImagePath:
                                        "${ImagePath.visaBg}${index + 1}.png",
                                    title: "businessLicense".tr(),
                                    cardNumber: '1183  1183  4289 8869',
                                    expireDate: '05/40',
                                    creationDate: '1441/10/09',
                                    holderName: 'ابراهيم اسامه احمد',
                                    onPressed: () => context
                                        .read<WalletCubit>()
                                        .onViewAllChanged(),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
