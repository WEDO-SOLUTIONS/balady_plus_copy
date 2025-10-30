import '/app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          return InkWell(
              onTap: () {
                AppConfig.changeLang(context);
              },
              child: Text(trans("changeLanguage")));
        }),
      ),
    );
  }
}
