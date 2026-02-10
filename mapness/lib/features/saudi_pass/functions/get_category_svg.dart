import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

Widget getCategorySvg(String categoryId, BuildContext context) => switch (categoryId) {
  Category.eat => Assets.imagesSvg.saudiPass.food.svg(color: context.colors.foregroundMuted),
  Category.homeAndAuto => Assets.imagesSvg.saudiPass.auto.svg(color: context.colors.foregroundMuted),
  Category.beautyAndHealth => Assets.imagesSvg.saudiPass.health.svg(color: context.colors.foregroundMuted),
  Category.entertainment => Assets.imagesSvg.saudiPass.plane.svg(color: context.colors.foregroundMuted),
  Category.shopping => Assets.imagesSvg.saudiPass.cart.svg(color: context.colors.foregroundMuted),
  Category.services => Assets.imagesSvg.saudiPass.service.svg(color: context.colors.foregroundMuted),
  _ => Assets.imagesSvg.saudiPass.service.svg(color: context.colors.foregroundMuted),
};
