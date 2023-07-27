import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show PermitCostBody, LicenseCostBody;

class LicenseCost extends StatelessWidget {
  final bool license;

  const LicenseCost({
    super.key,
    required this.license,
  });

  @override
  Widget build(BuildContext context) {
    return license ? const LicenseCostBody() : const PermitCostBody();
  }
}
