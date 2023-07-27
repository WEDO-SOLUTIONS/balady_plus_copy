import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../../../core/utils/utils_exports.dart';

class LoadingBubble extends StatefulWidget {
  const LoadingBubble({super.key});

  @override
  State<LoadingBubble> createState() => _LoadingBubbleState();
}

class _LoadingBubbleState extends State<LoadingBubble> {
  int _dotCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsetsDirectional.only(
          end: 8,
          bottom: 16,
        ),
        decoration: const ShapeDecoration(
          color: AppColor.primary100Light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _dotCount == index ? 1.0 : 0.3,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const ShapeDecoration(
                      color: AppColor.primary600Light,
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
