import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/classification_certificate_verify_bloc.dart';

class SearchNormalOptionsWidget extends StatelessWidget {
  final NormalSearchType type;
  final NormalSearchType? groupValue;

  const SearchNormalOptionsWidget({
    super.key,
    required this.type,
    this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).primaryColor,
        ),
      ),
      elevation: 0,
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: RadioListTile(
            value: type,
            groupValue: groupValue,
            onChanged: (val) {
              context.read<ClassificationCertificateVerifyBloc>().add(
                    SelectNormalSearchTypeClassificationCertificateState(
                      normalSearchType: type,
                    ),
                  );
            },
            title: Text(type.title.tr()),
            // subtitle: groupValue != null ? Text(type.description.tr()) : null,
          ),
        ),
      ),
    );
  }
}
