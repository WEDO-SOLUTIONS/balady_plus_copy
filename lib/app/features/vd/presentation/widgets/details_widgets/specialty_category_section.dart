import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        IncidentPhotoWidget,
        PreviousNextButtons,
        SplEmptyWidget,
        SplImagesListWidget,
        SplTypesCard,
        VDHeaderDescSearch,
        CreateVDBloc,
        CreateVDState,
        GetSPLDetailsEvent,
        SPLDetailsParams;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class SpecialityCategorySection extends StatefulWidget {
  const SpecialityCategorySection({Key? key}) : super(key: key);

  @override
  State<SpecialityCategorySection> createState() =>
      _SpecialityCategorySectionState();
}

class _SpecialityCategorySectionState extends State<SpecialityCategorySection> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateVDBloc, CreateVDState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VDHeaderDescSearch(
                              isSearchShown: state.isSearchShown ?? false,
                              header: ("vd_choose_spl").tr(),
                              desc: ("vd_choose_spl_desc").tr()),
                          Row(
                            children: [
                              (state.status == BlocStatus.loading)
                                  ? CustomShimmerWidget(
                                      childWidget: SplImagesListWidget(
                                          images: ["", ""], showSwipe: false),
                                    )
                                  : (state.status == BlocStatus.success &&
                                          state.splDetailsResponse != null &&
                                          (state.splDetailsResponse
                                                  ?.helpingImages?.isNotEmpty ??
                                              false))
                                      ? SplImagesListWidget(
                                          images: state.splDetailsResponse
                                              ?.helpingImages,
                                        )
                                      : SplEmptyWidget(),
                              const CustomHorizontalSpace(width: 10),
                              IncidentPhotoWidget(
                                image: state.getImagePath() ?? "",
                                height: 200,
                                width: getImageWidth(),
                              ),
                            ],
                          ),
                          CustomVerticalSpace(height: 20),
                          SizedBox(
                            height: 170,
                            child: (state.splItems?.isEmpty ?? false)
                                ? Center(
                                    child: CustomTextWidget(
                                      ('vd_no_search_result').tr(),
                                      fontColor: AppColor.black,
                                      fontSize: 17.0,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      fontWeight: AppFontWeight.medium,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Ink(
                                    color: Colors.transparent,
                                    child: ListView.builder(
                                        clipBehavior: Clip.none,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.splItems?.length ?? 0,
                                        itemBuilder: (ctx, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SplTypesCard(
                                              cardIcon: state.splItems?[index]
                                                      .getImageUrl() ??
                                                  "",
                                              cardText:
                                                  state.splItems?[index].name ??
                                                      "",
                                              onCardPressed: () {
                                                context
                                                    .read<CreateVDBloc>()
                                                    .add(GetSPLDetailsEvent(
                                                        selectedIndex: index,
                                                        params: SPLDetailsParams(
                                                            municipalityID: state
                                                                    .gisResponse
                                                                    ?.adminMunicipalityId ??
                                                                "",
                                                            splID: state
                                                                    .splItems?[
                                                                        index]
                                                                    .id ??
                                                                "")));
                                              },
                                              isSelected:
                                                  state.selectedSPLIndex ==
                                                      index,
                                            ),
                                          );
                                        }),
                                  ),
                          ),
                          CustomVerticalSpace(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                PreviousNextButtons()
              ],
            ),
          ],
        );
      },
    );
  }

  double getImageWidth() {
    double screenWidth = MediaQuery.of(context).size.width;
    double emptyWidth = MediaQuery.of(context).size.width / 2;
    double otherWidgetWidth = emptyWidth + 42;
    return screenWidth - otherWidgetWidth;
  }
}
