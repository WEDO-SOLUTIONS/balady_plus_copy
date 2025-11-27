import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class MockMiniAppsPage extends StatelessWidget {
  final String miniAppTitle;
  const MockMiniAppsPage({super.key, required this.miniAppTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          CommonFunctions.isAppAR ? Icons.arrow_forward : Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            miniAppTitle,
            style: const TextStyle(color: Colors.black, fontSize: 40),
          )),
        ],
      ),
    );
  }
}
