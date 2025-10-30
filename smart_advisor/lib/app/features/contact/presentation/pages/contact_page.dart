import 'package:flutter/material.dart';

import '/app/core/utils/constants/language.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("contact".tr()),
      ),
    );
  }
}
