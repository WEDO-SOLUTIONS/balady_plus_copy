import 'package:flutter/material.dart';

class SliderRightPage extends PageRouteBuilder {
  final Widget page;
  SliderRightPage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween<Offset>(begin: begin, end: end);
            final offsetAnimation = fAnimation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}

class SliderUpPage extends PageRouteBuilder {
  final Widget page;
  SliderUpPage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween<Offset>(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: fAnimation,
              curve: Curves.linearToEaseOut,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

class ScalePage extends PageRouteBuilder {
  final Widget page;
  ScalePage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            final tween = Tween<double>(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: fAnimation, curve: Curves.easeInBack);
            return ScaleTransition(
              scale: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

class RotatePage extends PageRouteBuilder {
  final Widget page;
  RotatePage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            final tween = Tween<double>(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: fAnimation, curve: Curves.linear);
            return RotationTransition(
              turns: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

class SizePage extends PageRouteBuilder {
  final Widget page;
  SizePage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            return SizeTransition(sizeFactor: fAnimation, child: child);
          },
        );
}

class FadePage extends PageRouteBuilder {
  final Widget page;
  FadePage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            return FadeTransition(opacity: fAnimation, child: child);
          },
        );
}

//! Two animations at same time
class ScaleRotatePage extends PageRouteBuilder {
  final Widget page;
  ScaleRotatePage({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 2500),
          reverseTransitionDuration: const Duration(milliseconds: 2500),
          pageBuilder: (context, fAnimation, sAnimation) => page,
          transitionsBuilder: (context, fAnimation, sAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            final tween = Tween<double>(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: fAnimation, curve: Curves.linear);
            return ScaleTransition(
              scale: tween.animate(curvedAnimation),
              child: RotationTransition(
                turns: tween.animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}
