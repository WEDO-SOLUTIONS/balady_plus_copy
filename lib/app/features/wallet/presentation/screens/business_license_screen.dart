import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../core/blocs/wallet_details/wallet_details_bloc.dart';
import '../../core/models/wallet_item.dart';
import '../../wallet_exports.dart';
import '../widgets/wallet_label_info.dart';
import '../widgets/wallet_user_image_widget.dart';

class BusinessLicenseScreen extends StatefulWidget {
  BusinessLicenseScreen({Key? key}) : super(key: key);

  @override
  State<BusinessLicenseScreen> createState() => _BusinessLicenseScreenState();
}

class _BusinessLicenseScreenState extends State<BusinessLicenseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openWalletDetails);
  }

  @override
  Widget build(BuildContext context) {
    WalletItem? item = ModalRoute.of(context)!.settings.arguments as WalletItem;

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
                Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      BusinessLicenseCard(
                        bgImagePath:
                            state.selectedItem?.getLicenseImage() ?? "",
                        title: state.selectedItem?.getLicenseHeaderText() ?? "",
                        cardNumber: state.selectedItem?.licenseId ?? "",
                        expireDate: state.selectedItem?.endDateHijri ?? "",
                        creationDate: state.selectedItem?.startDateHijri ?? "",
                        holderName: state.selectedItem?.getName() ?? "",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      Expanded(flex: 3, child: const _QrCodeCard()),
                      /*  Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButtonWidget.licenseDetails(
                          onPressed: () {},
                        ),
                      ),*/
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: state.status == BlocStatus.download
                        ? CircularProgressIndicator(
                            color: AppColor.white,
                          )
                        : ElevatedButtonWidget.licenseDetails(
                            onPressed: () {
                              context.read<WalletDetailsBloc>().checkPhoto();
                            },
                          ),
                  ),
                )
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: state.selectedItem?.getLicenseDetailsColor() ??
                  Color(0xffE1F6F6)
              /*  image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(ImagePath.qrBg),
            ),*/
              ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WalletUserImage(),
                    QrImageView(
                      data: state.selectedItem?.qrData ?? "",
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
                if (state.selectedItem?.getLicenseType() ==
                    LicenseTypes.peddler)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletLabelInfo(
                            title: "market_name".tr(),
                            subTitle: state.selectedItem?.marketName,
                          ),
                          WalletLabelInfo(
                            title: "port_number".tr(),
                            subTitle: state.selectedItem?.locationNumber,
                          ),
                        ],
                      ),
                      CustomVerticalSpace(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletLabelInfo(
                            title: "activity_name".tr(),
                            subTitle: state.selectedItem?.activityName,
                          ),
                        ],
                      ),
                    ],
                  )
              ],
            ),
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
          child: Stack(
            children: [
              Container(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
