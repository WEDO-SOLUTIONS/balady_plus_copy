import 'package:flutter/material.dart';

import '../../../qa/presentation/pages/qa_page.dart';
import 'building_requirements_page.dart';

class CompliancePage extends StatefulWidget {
  const CompliancePage({super.key});

  @override
  State<CompliancePage> createState() => _CompliancePageState();
}

class _CompliancePageState extends State<CompliancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuildingRequirementsPage(),
    );
  }
}

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return const QAPage();
  }
}

class Conditions extends StatelessWidget {
  const Conditions({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuildingRequirementsPage();
  }
}
