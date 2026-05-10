import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class GeneralErrorWidget extends StatelessWidget {
  final String error;
  final void Function() onPressed;
  const GeneralErrorWidget({super.key, required this.error, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 70, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: GeneralKey.appFontType),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  // backgroundColor: context.colors.accentDefault,
                  // foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("reload".tr(), style: const TextStyle(fontSize: 16, fontFamily: GeneralKey.appFontType)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
