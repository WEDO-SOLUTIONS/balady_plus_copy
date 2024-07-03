import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class ErrorSheetV2 extends StatelessWidget {
  const ErrorSheetV2({
    required this.onRetry,
    super.key,
    this.buttonLabel,
    this.onClose,
    this.errorTitle,
    this.errorContent,
    this.assetImage,
    this.package,
  });

  /// action how to recover state
  final VoidCallback onRetry;

  /// action when leave the sheet (default: pop)
  final VoidCallback? onClose;

  /// button label (localized default: reload)
  final String? buttonLabel;

  final String? errorTitle;
  final String? errorContent;
  final String? assetImage;
  final String? package;

  @override
  Widget build(BuildContext context) {
    Text styledText(String text, {bool isTitle = false}) => Text(
          text,
          textAlign: TextAlign.center,
          style: (isTitle ? context.textStyle.heading1 : context.textStyle.text)
              .copyWith(color: context.color.textAndIconsBasePrimary),
        );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: CustomCloseButton(
                onClose: onClose ?? () => context.pop(),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .7,
              child: Builder(
                builder: (context) {
                  if (assetImage == null || assetImage?.isEmpty == true) {
                    return SvgPicture.asset(
                      'assets/images_svg/sad_face.svg',
                      package: PackageConfig.packageName,
                    );
                  }

                  if (assetImage!.endsWith('.svg')) {
                    return SvgPicture.asset(
                      assetImage!,
                      package: package,
                    );
                  } else if (assetImage!.endsWith('.png')) {
                    return Image.asset(
                      assetImage!,
                      package: package,
                      fit: BoxFit.cover,
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(height: 24),
            FractionallySizedBox(
              widthFactor: .8,
              child: styledText(errorTitle ?? '', isTitle: true),
            ),
            const SizedBox(height: 4),
            FractionallySizedBox(
              widthFactor: .8,
              child: styledText(errorContent ?? ''),
            ),
            const SizedBox(height: 24),
            LabeledElevatedButton(
              onPressed: onRetry,
              label: buttonLabel ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
