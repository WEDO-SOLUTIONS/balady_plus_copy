import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

Widget getCategorySvg(String categoryId) => switch (categoryId) {
      Category.eat => Assets.imagesSvg.saudiPass.food.svg(),
      Category.homeAndAuto => Assets.imagesSvg.saudiPass.auto.svg(),
      Category.beautyAndHealth => Assets.imagesSvg.saudiPass.health.svg(),
      Category.entertainment => Assets.imagesSvg.saudiPass.plane.svg(),
      Category.shopping => Assets.imagesSvg.saudiPass.cart.svg(),
      Category.services => Assets.imagesSvg.saudiPass.service.svg(),
      _ => Assets.imagesSvg.saudiPass.service.svg(),
    };
