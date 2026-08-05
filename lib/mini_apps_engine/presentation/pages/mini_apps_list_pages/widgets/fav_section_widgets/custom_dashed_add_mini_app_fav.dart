import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/add_fav_mini_apps.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

//!
class CustomDashedAddMiniAppFav extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final String? text;
  const CustomDashedAddMiniAppFav({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.child,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final gap = (4.0 * textScale).clamp(0.0, 10.0);
    final gapHeight = (context.screenHeight * 0.02) + gap;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    BlocProvider.value(value: context.read<NewMiniAppLogicCubit>(), child: const AddFavMiniApps()),
              ),
            );
          },
          child: SizedBox(
            width: width ?? context.w(60),
            height: height ?? context.h(60),
            child: DottedBorder(
              // 1. CHANGE THIS CLASS TO RoundedRectDottedBorderOptions
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(10), // Now you can add the radius!
                borderPadding: EdgeInsets.zero,
                padding: const EdgeInsets.all(2),
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
                gradient: null,
                dashPattern: const <double>[4, 5],
                stackFit: StackFit.loose,
                strokeCap: StrokeCap.round,
              ),
              // 2. Wrap the icon in a Container to give it that faint light-green background
              child: Center(
                child: SizedBox(
                  width: context.w(44),
                  height: context.h(44),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryFixed, // The light background
                      borderRadius: BorderRadius.circular(10), // Match the radius above
                    ),
                    child: Center(child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: gapHeight),
        SizedBox(
          width: context.screenWidth * 0.15,
          height: context.screenHeight * 0.045 * textScale,
          child: Center(
            child: Text(
              text ?? "add".tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 14.43 / 13,
                fontWeight: FontWeight.w500,
                fontFamily: GeneralKey.appFontType,
                // color:  Color(0xFF1E2A36),
                leadingDistribution: TextLeadingDistribution.even,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
