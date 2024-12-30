import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

class MapLostInternet extends StatelessWidget {
  final VoidCallback onTap;

  const MapLostInternet({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BaseErrorWidget(
        errorLabel: context.l10n.youDontSeemToHaveInternetDescription,
        buttonLabel: context.l10n.tryAgain,
        onRetry: onTap,
      );
}
