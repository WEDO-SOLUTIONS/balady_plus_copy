import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/add_fav_mini_apps.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<NewMiniAppLogicCubit>(),
                  child: const AddFavMiniApps(),
                ),
              ),
            );
          },
          child: SizedBox(
            width: width ?? context.w(53.95),
            height: height ?? context.h(53.95),
            child: DottedBorder(
              options: RectDottedBorderOptions(
                // radius: const Radius.circular(16),
                // borderType: BorderType.RRect,
                color: const Color(0XFF809AA4),
                strokeWidth: 2,
                dashPattern: const [2.2084856033325195, 2.2084856033325195],
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: context.screenWidth * 0.15,
          height: context.screenHeight * 0.04,
          child: Center(
            child: Text(
              text ?? "add2".tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 14.43 / 13,
                fontWeight: FontWeight.w400,
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
