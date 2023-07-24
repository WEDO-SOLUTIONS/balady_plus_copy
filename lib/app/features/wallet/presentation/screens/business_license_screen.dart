import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../wallet_exports.dart';

class BusinessLicenseScreen extends StatelessWidget {
  const BusinessLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: "businessLicense".tr()),
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
                  title: "businessLicense".tr(),
                  cardNumber: '1183  1183  4289 8869',
                  expireDate: '05/40',
                  creationDate: '1441/10/09',
                  holderName: 'ابراهيم اسامه احمد',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                const _QrCodeCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrCodeCard extends StatelessWidget {
  const _QrCodeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 206,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImagePath.qrBg),
        ),
      ),
      child: Column(
        children: [
          QrImageView(
            data: '1234567890',
            size: 92,
          ),
          const SizedBox(height: 24),
          CustomTextWidget(
            "scanQr".tr(),
            fontColor: AppColor.primary600Light,
            fontWeight: AppFontWeight.bold,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}

class _BusinessLicenseFooter extends StatelessWidget {
  const _BusinessLicenseFooter();

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
