import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_list/bloc/classification_certificate_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/classification_certificate_list_cubit.dart';
import 'classification_certificate_item_widget.dart';

class ClassificationCertificateListWidget extends StatelessWidget {
  const ClassificationCertificateListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ClassificationCertificateListCubit cubit =
        context.watch<ClassificationCertificateListCubit>();
    return BlocBuilder<ClassificationCertificateListCubit,
        ClassificationCertificateListState>(
      bloc: cubit,
      builder: (_, state) {
        if (state is LoadingListClassificationCertificateState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is NoListClassificationCertificateDebtState) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(IconPath.noEvents),
                  const SizedBox(height: 20),
                  Text('noSearchFounded'.tr()),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('back_to_search'.tr()),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is FieldListClassificationCertificateState) {
          return ReloadWidget(
            onTab: () => cubit.searchClassificationCertificate(
              searchRequestModel: state.searchRequestModel,
            ),
          );
        }
        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        // View Loading In after list item in list
        if (state is SucceedWithPaginationListClassificationCertificateState) {
          ScrollController scrollController = ScrollController();
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index == state.classificationCertificateItem.length
                  ? const Center(child: CircularProgressIndicator())
                  : ClassificationCertificateItemWidget(
                      classificationCertificate:
                          state.classificationCertificateItem[index],
                    );
            },
            controller: scrollController
              ..addListener(
                () {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    cubit.searchClassificationCertificate(
                      searchRequestModel: state.searchRequestModel,
                    );
                  }
                },
              ),
            itemCount: state.classificationCertificateItem.length + 1,
          );
        }

        if (state is SuccessListClassificationCertificateState) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ClassificationCertificateItemWidget(
                classificationCertificate:
                    state.classificationCertificateItem[index],
              );
            },
            itemCount: state.classificationCertificateItem.length,
          );
        }
        return const SizedBox();
      },
    );
  }
}
