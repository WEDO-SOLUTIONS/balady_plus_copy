import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

Widget getCategorySvg(String categoryId, BuildContext context) => switch (categoryId) {
  // ignore: deprecated_member_use_from_same_package
  Category.eat => Assets.imagesSvg.saudiPass.auto.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  Category.homeAndAuto => Assets.imagesSvg.saudiPass.auto.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  Category.beautyAndHealth => Assets.imagesSvg.saudiPass.health.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  Category.entertainment => Assets.imagesSvg.saudiPass.plane.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  Category.shopping => Assets.imagesSvg.saudiPass.cart.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  Category.services => Assets.imagesSvg.saudiPass.service.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
  _ => Assets.imagesSvg.saudiPass.service.svg(
    colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
  ),
};
