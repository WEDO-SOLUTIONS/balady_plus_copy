import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen.dart';
import 'package:mapness/features/saudi_pass/widgets/settings_screen_widget.dart';

@RoutePage()
class SettingsScreenPage extends StatelessWidget {
  final SettingsScreen settingsScreen;

  const SettingsScreenPage({required this.settingsScreen, super.key});

  @override
  Widget build(BuildContext context) => SettingsScreenWidget(settingsScreen: settingsScreen);
}
