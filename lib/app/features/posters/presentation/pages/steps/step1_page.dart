import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../blocs/posters_license_bloc.dart';
import '../../widgets/license_widgets/license_item_widget.dart';
import '../../widgets/previous_next_button.dart';

class PostersStep1Page extends StatelessWidget {
  const PostersStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CRHeaderDesc(header: "licenses_list"),
                        const SizedBox(height: 12),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.selectedLicenses?.length ?? 0,
                            itemBuilder: (ctx, index) {
                              return PostersLicenseItemWidget();
                            })
                      ],
                    ),
                  ),
                ),
              ),
              PostersPreviousNextButtons(
                isBtnDisabled: false,
                onPressed: () {
                  //  context.read<MapBloc>().add(const SaveLocationDataEvent());
                },
              ),
            ],
          ),
          if (state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
