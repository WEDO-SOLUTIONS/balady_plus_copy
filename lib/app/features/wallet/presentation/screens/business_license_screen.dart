import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../core/blocs/wallet_details/wallet_details_bloc.dart';
import '../../core/models/wallet_item.dart';
import '../../wallet_exports.dart';
import '../widgets/wallet_label_info.dart';
import '../widgets/wallet_user_image_widget.dart';

class BusinessLicenseScreen extends StatelessWidget {
  final WalletItem? item;
  const BusinessLicenseScreen({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletDetailsBloc(item),
      child: BlocConsumer<WalletDetailsBloc, WalletDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
                title: state.selectedItem?.getLicenseHeaderText()),
            body: Stack(
              children: [
                const _BusinessLicenseFooter(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      BusinessLicenseCard(
                        bgImagePath: "${ImagePath.visaBg}1.png",
                        title: state.selectedItem?.getLicenseHeaderText() ?? "",
                        cardNumber: state.selectedItem?.licenseId ?? "",
                        expireDate: state.selectedItem?.endDateHijri ?? "",
                        creationDate: state.selectedItem?.startDateHijri ?? "",
                        holderName: state.selectedItem?.getName() ?? "",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      const _QrCodeCard(),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButtonWidget.licenseDetails(
                          onPressed: () {},
                        ),
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

class _QrCodeCard extends StatelessWidget {
  const _QrCodeCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletDetailsBloc, WalletDetailsState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 26),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: AppColor.primary300Light
              /*  image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(ImagePath.qrBg),
            ),*/
              ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WalletUserImage(),
                  QrImageView(
                    data: state.selectedItem?.qrUrl ?? "",
                    size: 92,
                  ),
                ],
              ),
              CustomVerticalSpace(height: 12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WalletLabelInfo(
                        title: "id_number".tr(),
                        subTitle: state.selectedItem?.getOwnerId(),
                      ),
                    ],
                  ),
                  CustomVerticalSpace(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WalletLabelInfo(
                        title: "digitalWalletCardMunicipalityWord".tr(),
                        subTitle: state.selectedItem?.municipilityName,
                      ),
                      WalletLabelInfo(
                        title: "digitalWalletCardSubMunicipalityWord".tr(),
                        subTitle: state.selectedItem?.subMunicipilityName,
                      )
                    ],
                  ),
                ],
              ),
              CustomVerticalSpace(height: 12),
              if (state.selectedItem?.getLicenseType() == LicenseTypes.peddler)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WalletLabelInfo(
                          title: "activity_name".tr(),
                          subTitle: state.selectedItem?.activityName,
                        ),
                        WalletLabelInfo(
                          title: "market_name".tr(),
                          subTitle: state.selectedItem?.marketName,
                        )
                      ],
                    ),
                    CustomVerticalSpace(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WalletLabelInfo(
                          title: "port_number".tr(),
                          subTitle: state.selectedItem?.locationNumber,
                        ),
                        WalletLabelInfo(
                          title: "market_name".tr(),
                          subTitle: state.selectedItem?.marketName,
                        )
                      ],
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}

class _BusinessLicenseFooter extends StatelessWidget {
  const _BusinessLicenseFooter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletDetailsBloc, WalletDetailsState>(
      builder: (context, state) {
        return Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 24,
            ),
            height: MediaQuery.sizeOf(context).height / 1.6,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.walletBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButtonWidget.licenseDetails(
                onPressed: () {
                  context
                      .read<WalletDetailsBloc>()
                      .add(ShareWalletItem(selectedIetm: state.selectedItem));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
