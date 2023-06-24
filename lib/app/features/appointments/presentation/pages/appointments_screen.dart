import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../widgets/appointments_widgets/appointments_body_widget.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();

    //MM Helpers.sendEventToAnalytics(AppEvents.Appointments_MiniApp);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white2,
      body: Column(
        children: [Expanded(child: AppointmentsBodyWidget())],
      ),
    );
  }
}
