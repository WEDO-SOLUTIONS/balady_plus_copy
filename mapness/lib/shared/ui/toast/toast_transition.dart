part of 'toast_overlay.dart';

class _ToastTransition extends StatefulWidget {
  final String title;
  final String? actionText;
  final VoidCallback hide;
  final VoidCallback? onActionTap;
  final String? iconAsset;
  final IconData? iconData;
  final Duration displayDuration;
  final Duration transitionDuration;
  final bool? isDismissible;

  const _ToastTransition({
    required this.hide,
    required this.title,
    required this.iconAsset,
    required this.iconData,
    required this.transitionDuration,
    required this.displayDuration,
    this.isDismissible,
    this.actionText,
    this.onActionTap,
  });

  @override
  State<_ToastTransition> createState() => __ToastTransitionState();
}

class __ToastTransitionState extends State<_ToastTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();

    Future.delayed(widget.displayDuration, _hide);
  }

  Future<void> _hide() async {
    await _controller.reverse();
    if (_controller.isCompleted || _controller.isDismissed) {
      widget.hide();
    }
  }

  void _onActionTap() {
    _hide();
    widget.onActionTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.isDismissible ?? false
      ? Dismissible(
          key: UniqueKey(),
          onDismissed: (_) => _hide(),
          direction: DismissDirection.up,
          child: SlideTransition(
            position: _animation,
            child: _ToastWidget(
              title: widget.title,
              actionText: widget.actionText,
              onActionTap: _onActionTap,
              iconAsset: widget.iconAsset,
              iconData: widget.iconData,
            ),
          ),
        )
      : _ToastWidget(
          title: widget.title,
          actionText: widget.actionText,
          onActionTap: _onActionTap,
          iconAsset: widget.iconAsset,
          iconData: widget.iconData,
        );
}
