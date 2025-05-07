part of 'toast_overlay.dart';

class _ToastTransition extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? firstText;
  final String? secondText;
  final VoidCallback hide;
  final VoidCallback? onFirstTap;
  final VoidCallback? onSecondTap;
  final String? iconAsset;
  final IconData? iconData;
  final Color? iconColor;
  final Duration displayDuration;
  final Duration transitionDuration;
  final bool? isDismissible;
  final bool isClosable;
  final bool isFlipped;

  const _ToastTransition({
    required this.hide,
    required this.title,
    required this.iconAsset,
    required this.iconData,
    required this.transitionDuration,
    required this.displayDuration,
    this.titleStyle,
    this.isDismissible,
    this.isClosable = false,
    this.isFlipped = false,
    this.firstText,
    this.onFirstTap,
    this.iconColor,
    this.onSecondTap,
    this.secondText,
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
    if (mounted) {
      await _controller.reverse();
    }
    if (_controller.isCompleted || _controller.isDismissed) {
      widget.hide();
    }
  }

  void _onFirstTap() {
    _hide();
    widget.onFirstTap?.call();
  }

  void _onSecondTap() {
    _hide();
    widget.onSecondTap?.call();
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
              titleStyle: widget.titleStyle,
              firstText: widget.firstText,
              secondText: widget.secondText,
              onFirstTap: _onFirstTap,
              onSecondTap: _onSecondTap,
              iconAsset: widget.iconAsset,
              iconData: widget.iconData,
              iconColor: widget.iconColor,
              isFlipped: widget.isFlipped,
            ),
          ),
        )
      : _ToastWidget(
          title: widget.title,
          titleStyle: widget.titleStyle,
          firstText: widget.firstText,
          secondText: widget.secondText,
          onFirstTap: _onFirstTap,
          onSecondTap: _onSecondTap,
          iconAsset: widget.iconAsset,
          iconData: widget.iconData,
          iconColor: widget.iconColor,
          isFlipped: widget.isFlipped,
        );
}
