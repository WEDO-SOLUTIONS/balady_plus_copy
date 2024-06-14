import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class MapLostInternet extends StatelessWidget {
  const MapLostInternet({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          NumericBase.$12x.heightBox,
          Text(
            '${context.l10n.failedToLoadData}\n${context.l10n.tryAgainLater}',
            style: context.textStyle.text,
          ),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              padding: const EdgeInsets.all(NumericBase.$4x),
              primaryLabel: context.l10n.tryAgain,
              buttonColorScheme: ButtonColorScheme.primary,
              onTap: onTap,
            ),
          ),
        ],
      );
}
