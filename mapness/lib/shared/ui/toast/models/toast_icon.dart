part of '../toast_overlay.dart';

/// Icon for the toast. Placed on the end side of the title.
sealed class ToastIcon {
  final Color? color;

  const ToastIcon({
    this.color,
  });
}

class ToastIconAsset extends ToastIcon {
  final String asset;

  const ToastIconAsset(this.asset, {super.color});
}

class ToastIconData extends ToastIcon {
  final IconData data;

  const ToastIconData(this.data, {super.color});
}
