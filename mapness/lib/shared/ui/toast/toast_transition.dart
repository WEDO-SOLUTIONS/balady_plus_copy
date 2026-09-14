part of 'toast_overlay.dart';

class _ToastTransition extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final List<ToastAction>? actions;
  final VoidCallback hide;
  final ToastIcon? icon;
  final Duration displayDuration;
  final Duration transitionDuration;
  final bool? isDismissible;
  final bool isClosable;
  final bool isFlipped;

  const _ToastTransition({
    required this.hide,
    required this.title,
    required this.icon,
    required this.transitionDuration,
    required this.displayDuration,
    this.titleStyle,
    this.isDismissible,
    this.actions,
    this.isClosable = false,
    this.isFlipped = false,
  });

  @override
  State<_ToastTransition> createState() => __ToastTransitionState();
}

class __ToastTransitionState extends State<_ToastTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;
  late final List<ToastAction> _actions;
  Timer? _hideTimer;
  bool _isHiding = false;

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
    _actions = widget.actions?.map((e) => e.copyWith(onTap: () => _onActionTap(e))).nonNulls.toList() ?? [];
    _hideTimer = Timer(widget.displayDuration, () => detach(_hide(), tag: 'toastTransition.hide'));
  }

  Future<void> _hide() async {
    if (_isHiding || !mounted) {
      return;
    }

    _isHiding = true;
    _hideTimer?.cancel();

    await _controller.reverse();
    if (mounted) {
      widget.hide();
    }
  }

  void _onActionTap(ToastAction action) {
    detach(_hide(), tag: 'toastTransition.hide');
    action.onTap?.call();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
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
              titleStyle: widget.titleStyle,
              actions: _actions,
              icon: widget.icon,
              isFlipped: widget.isFlipped,
            ),
          ),
        )
      : _ToastWidget(
          title: widget.title,
          titleStyle: widget.titleStyle,
          actions: _actions,
          icon: widget.icon,
          isFlipped: widget.isFlipped,
        );
}
