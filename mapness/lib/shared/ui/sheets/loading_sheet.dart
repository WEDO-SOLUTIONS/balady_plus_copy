import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

/// A widget that displays a loading indicator in a sheet.
class LoadingSheet extends StatelessWidget {
  const LoadingSheet({
    super.key,
    this.title,
    this.onClose,
  });

  /// The title of the loading indicator.
  final String? title;

  /// The action to be taken when the close button is pressed.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 338,
          width: double.infinity,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: SheetDragger(),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: CustomCloseButton(
                  onClose: onClose ?? () => context.router.pop(),
                ),
              ),
              Center(
                child: Loading.large(
                  color: context.colors.accentDefault,
                  backgroundColor: context.colors.accentDefault.withOpacity(0.1),
                  title: title,
                  orientation: Axis.vertical,
                  isDisplayTitle: title != null,
                ),
              ),
            ],
          ),
        ),
      );
}
