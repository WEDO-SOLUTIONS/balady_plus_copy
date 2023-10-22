import 'package:flutter/material.dart';

// class GaurdScreen extends StatelessWidget {
//   GaurdScreen({super.key});

//   OverlayEntry? _story;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F1011),
//       body: Column(
//         children: [
//           SafeArea(
//             child: ElevatedButton(
//               onPressed: () {
//                 Overlay.of(context).insert(story());
//               },
//               child: const Text("Story"),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void removeEntry() {
//     _story?.remove();
//     _story = null;
//   }

//   OverlayEntry story() {
//     _story = OverlayEntry(
//       builder: (context) {
//         return StoryContainer(
//           onDismiss: () {
//             removeEntry();
//           },
//         );
//       },
//     );
//     return _story!;
//   }
// }

class StoryContainer extends StatefulWidget {
  final Widget child;
  const StoryContainer({
    super.key,
    required this.onDismiss,
    required this.child,
  });

  final void Function() onDismiss;

  @override
  State<StoryContainer> createState() => _StoryContainerState();
}

class _StoryContainerState extends State<StoryContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    )..addStatusListener(
        (AnimationStatus status) {
          if (status == AnimationStatus.dismissed) {
            widget.onDismiss();
          }
        },
      );
    _controller.forward();
  }

  void dismiss() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _controller.value -= details.delta.dy / MediaQuery.of(context).size.height;
      },
      onVerticalDragEnd: (details) {
        print(details.velocity.pixelsPerSecond.dy);
        final predictedValue =
            _controller.value - details.velocity.pixelsPerSecond.dy * 0.25 / MediaQuery.of(context).size.height;
        if (predictedValue < 0.6) {
          _controller.reverse(from: _controller.value);
        } else {
          _controller.forward(from: _controller.value);
        }
      },
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: _opacityAnimation.value,
                child: const ColoredBox(
                  color: Colors.red,
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    0.0,
                    MediaQuery.of(context).size.height * (1 - _opacityAnimation.value),
                    0.0,
                  )
                  ..scale(
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                    0.8 + 0.2 * _opacityAnimation.value,
                  ),
                origin: Offset(MediaQuery.of(context).size.width * 0.5, 0),
                child: SafeArea(
                  child: child!,
                ),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
