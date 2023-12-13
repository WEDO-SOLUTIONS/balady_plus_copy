import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, RouteName;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomTextFieldWidget,
        CustomTextWidget,
        DefaultAppBarWidget,
        DrawIconBasedTypeWidget,
        TabPageContainer;
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import '../../services_exports.dart'
    show
        SearchServicesTextField,
        ServiceEntity,
        ServiceIcon,
        ServicesCubit,
        ServicesList,
        ServicesState;
import '../widgets/enhanced_app_bar.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<ServiceEntity> searchedServices = [];
  String query = "";
  @override
  Widget build(BuildContext context) {
    List<ServiceEntity> services = (ModalRoute.of(context)!.settings.arguments
            as (List<ServiceEntity>, String))
        .$1;
    String title = (ModalRoute.of(context)!.settings.arguments as (
      List<ServiceEntity>,
      String
    ))
        .$2;
    if (searchedServices.isEmpty && query.isEmpty) {
      searchedServices.addAll(services);
    }

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: EnhancedAppBar(
        title: title,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 67,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextFieldWidget(
                hintText: 'search'.tr(),
                fillColor: Color(0xffF5F7FA),
                prefixIcon: const DrawIconBasedTypeWidget(
                  icon: Icons.search,
                  iconSize: 24,
                  iconColor: Color(0x5C1E2A36),
                ),
                borderRadius: 8,
                textFieldVerticalPadding: 16,
                onChanged: (String t) {
                  query = t;
                  searchedServices = services
                      .where((element) => element.title.contains(t))
                      .toList();

                  setState(() {});
                },
                textFieldStyle: TextStyle(
                    color: Color(0x5C1E2A36),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                borderColor: Colors.transparent,
                /* suffixIcon: _textEditingController.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _textEditingController.text = '';
                      context.read<ServicesCubit>().toggleSearchField();
                    },
                    child: const DrawIconBasedTypeWidget(
                      icon: Icons.close,
                      iconColor: AppColor.blackModern600Light,
                    ),
                  )
                : null,*/
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: searchedServices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              itemBuilder: (_, index) {
                return ServiceIcon(
                  service: searchedServices[index],
                  width: 72,
                  height: 112,
                  backgroundColor: Color(0xffF5F7FA),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
