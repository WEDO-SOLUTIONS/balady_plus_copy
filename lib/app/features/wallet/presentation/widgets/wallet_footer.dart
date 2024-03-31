import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../core/blocs/wallet/wallet_bloc.dart';

class WalletFooter extends StatelessWidget {
  const WalletFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) => previous.showAll != current.showAll,
      builder: (context, state) {
        return state.showAll ?? false
            ? const SizedBox()
            : Positioned(
                bottom: 0,
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.04),
                  height: MediaQuery.sizeOf(context).height / 1.8,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.walletBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomTextWidget(
                      "toViewAllLicense".tr(),
                      fontSize: 14,
                      maxLines: null,
                      height: 1.5,
                      textAlign: TextAlign.center,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.secondary100Light,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
