import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/create_compliance_location_widgets/create_compliance_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateComplianceLocationPage extends StatelessWidget {
  const CreateComplianceLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateComplianceLocationWidget(),
    );
  }
}
