import 'package:flutter/material.dart';

class SplEmptyWidget extends StatelessWidget {
  const SplEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/icons/png/vd/spl_empty.png",
        height: 279, width: MediaQuery.of(context).size.width / 2);
  }
}
