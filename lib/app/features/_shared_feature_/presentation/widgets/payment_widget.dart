import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../entry_point/domain/entities/payment_request.dart';

class PaymentWidget extends StatelessWidget {
  final String billNumber;
  final String requestKey;
  const PaymentWidget({super.key, required this.billNumber, required this.requestKey});

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWidget.primaryCustom(
        onPressed: () async {
          EasyLoading.show();
          final String? url = await sl<EntryPointCubit>()
              .getPaymentURL(PaymentRequest(accountNumber: billNumber, requestId: requestKey));
          EasyLoading.dismiss();

          if (url != null) CommonFunctions.openBaladyWebView(url, isObjections: false);
        },
        text: "pay_bill".tr());
  }
}
