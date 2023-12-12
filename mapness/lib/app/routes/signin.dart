import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/sso_auth/presentation/signin_screen.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'signin.g.dart';

@TypedGoRoute<SignInRoute>(
  path: '/signin',
)
class SignInRoute extends GoRouteData {
  const SignInRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const TransculentPage(
      child: SigninScreen(),
    );
  }
}

final $SignInRoutes = $appRoutes;
