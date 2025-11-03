import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/settings_screen_view_widget.dart';

@RoutePage()
class SettingsScreenViewPage extends StatelessWidget {
  final SettingsScreenView settingsScreenView;

  const SettingsScreenViewPage({required this.settingsScreenView, super.key});

  @override
  Widget build(BuildContext context) => SettingsScreenViewWidget(settingsScreenView: settingsScreenView);
}
