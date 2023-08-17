import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../home_exports.dart';

class DraggableHeaderComponent extends StatefulWidget {
  const DraggableHeaderComponent({
    super.key,
  });

  @override
  State<DraggableHeaderComponent> createState() =>
      _DraggableHeaderComponentState();
}

class _DraggableHeaderComponentState extends State<DraggableHeaderComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryPointCubit, EntryPointState>(
      builder: (context, state) {
        bool isLoggedIn = CommonProperties.isLoggedIn;
        String pm = isLoggedIn ? "مساء الخير  " : "مساء الخير";
        String am = isLoggedIn ? "صباح الخير  " : "صباح الخير";
        return Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackModern900Light.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              color: AppColor.scaffoldBackground),
          child: Column(
            children: [
              const DrawLineWidget(
                lineWidth: 32,
                lineHeight: 4,
                lineColor: AppColor.gray10,
                radius: 46.0,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomTextWidget(
                        DateTime.now().hour > 12 ? pm : am,
                        fontSize: 14,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.blackModern600Light,
                      ),
                      CustomTextWidget(
                        CommonProperties.userInfo?.getFirstAndLastName() ?? '',
                        fontSize: 18,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.primary900Light,
                      ),
                    ],
                  ),
                  const CurrentWeather(),
                ],
              ),
              const SizedBox(height: 16),
              BlocBuilder<EntryPointCubit, EntryPointState>(
                  bloc: sl(),
                  builder: (context, authState) {
                    return CustomTextFieldWidget(
                      hintText: authState.getSearchText(),
                      //   hintText: 'ابحث عن...'.tr(),
                      controller: searchController,
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackModern600Light,
                        height: 1,
                      ),
                      textFieldVerticalPadding: 16,
                      suffixIcon: const DrawIconBasedTypeWidget(
                        icon: IconPath.search,
                        iconSize: 20,
                        iconColor: AppColor.primary900Light,
                      ),
                      borderRadius: 26,
                      borderColor: AppColor.primary900Light.withOpacity(0.1),
                      onSubmitted: (text) {
                        if (text.isNotEmpty) {
                          MapViewModel mapViewModel =
                              Provider.of<MapViewModel>(context, listen: false);

                          mapViewModel.performSearch(
                              queryText: text, showLoader: true);
                        }
                      },
                    );
                  }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
