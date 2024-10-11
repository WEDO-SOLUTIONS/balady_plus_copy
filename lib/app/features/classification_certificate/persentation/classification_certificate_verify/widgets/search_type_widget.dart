import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/bloc/classification_certificate_verify_bloc.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchTypeWidget extends StatelessWidget {
  final SearchMethod typeMethod;
  final SearchMethod selectedTypeMethod;

  const SearchTypeWidget({
    super.key,
    required this.typeMethod,
    required this.selectedTypeMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: 0,
      color: selectedTypeMethod == typeMethod
          ? Theme.of(context).primaryColor
          : Colors.transparent,
      child: InkWell(
        onTap: () {

          context.read<ClassificationCertificateVerifyBloc>().add(
                SelectSearchMethodClassificationCertificateState(
                  typeMethod: typeMethod,
                ),
              );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              typeMethod.title.tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: selectedTypeMethod == typeMethod
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
