import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath, RouteName;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomTextFieldWidget,
        CustomTextWidget,
        DefaultAppBarWidget,
        DrawIconBasedTypeWidget,
        TabPageContainer;
import '../../../home_page/home_exports.dart' show CircleIcon;

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
    Color? textColor =
        CommonFunctions.isFoundationDay() ? Color(0xff6B4E45) : null;
    return ChangeNotifierProvider(
      create: (context) => ChatBotProvider(
        sl(),
        // Make The Section id to send with all question in the Section and send to
        // rating API switch the request id
        sectionId: DateTime.now().millisecondsSinceEpoch,
      ),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: EnhancedAppBar(
          title: title,
          actions: [],
        ),
        body: Column(
          children: [
            Container(
              height: 67,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextFieldWidget(
                hintText: 'search'.tr(),
                fillColor: Color(0xffF5F7FA),
                prefixIcon: DrawIconBasedTypeWidget(
                  icon: Icons.search,
                  iconSize: 24,
                  iconColor: textColor ?? Color(0x5C1E2A36),
                ),
                borderRadius: 8,
                textFieldVerticalPadding: 16,
                onChanged: (String t) {
                  query = t;
                  searchedServices = services
                      .where((element) => element.title
                      .tr()
                      .toLowerCase()
                      .contains(t.toLowerCase()))
                      .toList();

                  setState(() {});
                },
                hintStyle: TextStyle(
                    color: textColor ?? Color(0x5C1E2A36),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                textFieldStyle: TextStyle(
                    color: textColor ?? Color(0x5C1E2A36),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: searchedServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 40.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemBuilder: (_, index) {
                    return ServiceIcon(
                      service: searchedServices[index],
                      width: 72,
                      backgroundColor: Color(0xffF5F7FA),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
