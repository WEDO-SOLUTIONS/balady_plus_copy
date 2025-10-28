part of '../toast_overlay.dart';

/// Low line of text action with a callback. Placed below the title.
class ToastAction {
  final String title;
  final void Function()? onTap;

  const ToastAction({
    required this.title,
    this.onTap,
  });

  ToastAction copyWith({
    String? title,
    void Function()? onTap,
  }) =>
      ToastAction(
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
      );
}
