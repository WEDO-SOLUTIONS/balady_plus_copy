import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class PoiLoadingSheet extends StatelessWidget {
  const PoiLoadingSheet({super.key});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 148,
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
                  onClose: () {
                    context.router.maybePop();
                  },
                ),
              ),
              Center(
                child: Loading.medium(title: context.l10n.loading),
              ),
            ],
          ),
        ),
      );
}
