import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';

import '../../bloc/classification_certificate_verify_bloc.dart';
import 'search_normal_options_widget.dart';

class NormalSearchListWidget extends StatelessWidget {
  final NormalSearchClassificationCertificateState state;

  const NormalSearchListWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: state.normalSearchTypeList
          .map((searchType) => SearchNormalOptionsWidget(type: searchType))
          .toList(),
    );
  }
}
