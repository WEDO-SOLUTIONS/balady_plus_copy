import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/bloc/classification_certificate_verify_bloc.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/title_with_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdvancedSearchWidget extends StatelessWidget {
  final AdvancedMethodClassificationCertificateState state;

  const AdvancedSearchWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "verified_by".tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ClassificationCertificateVerifyBloc>().add(
                      SelectSearchMethodClassificationCertificateState(
                        typeMethod: state.typeMethod,
                      ),
                    );
              },
              child: Text("clear_all".tr()),
            ),
          ],
        ),
        TitleWithWidget(
          title: 'type',
          isRequired: true,
          widget: DropdownButtonFormField<String>(
            hint: Text("select".tr()),
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) => value == null ? 'field required'.tr() : null,
            onChanged: (String? menu) {},
            items:
                ["menuItems", "String", "test"].map<DropdownMenuItem<String>>(
              (String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'sector',
          isRequired: true,
          widget: DropdownButtonFormField<String>(
            hint: Text("select_sector".tr()),
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) => value == null ? 'field required'.tr() : null,
            onChanged: (String? menu) {},
            items:
                ["menuItems", "String", "test"].map<DropdownMenuItem<String>>(
              (String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'city',
          isRequired: true,
          widget: DropdownButtonFormField<String>(
            hint: Text("city_select".tr()),
            icon: Image.asset(IconPath.arrowCircleDown, width: 24, height: 24),
            validator: (value) => value == null ? 'field required'.tr() : null,
            onChanged: (String? menu) {},
            items:
                ["menuItems", "String", "test"].map<DropdownMenuItem<String>>(
              (String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'activity',
          widget: DropdownMenu<String>(
            //initialSelection: menuItems.first,
            // controller: menuController,
            width: double.maxFinite,
            expandedInsets: EdgeInsets.zero,
            hintText: "select_activity".tr(),
            requestFocusOnTap: true,
            enableFilter: true,
            trailingIcon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            onSelected: (String? menu) {},
            dropdownMenuEntries: ["menuItems", "String", "test"]
                .map<DropdownMenuEntry<String>>((String menu) {
              return DropdownMenuEntry<String>(
                value: menu,
                label: menu,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'certificate_degree',
          widget: DropdownMenu<String>(
            //initialSelection: menuItems.first,
            // controller: menuController,
            width: double.maxFinite,
            expandedInsets: EdgeInsets.zero,
            hintText: "select_degree".tr(),
            requestFocusOnTap: true,
            enableFilter: true,
            trailingIcon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            onSelected: (String? menu) {},
            dropdownMenuEntries: ["menuItems", "String", "test"]
                .map<DropdownMenuEntry<String>>((String menu) {
              return DropdownMenuEntry<String>(
                value: menu,
                label: menu,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        ////////////////////////////
        TitleWithWidget(
          title: 'certificate_expiration_date_from',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            readOnly: true,
            onTap: () {

            },
            decoration: InputDecoration(
                hintText: "select_date".tr(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    IconPath.calendar,
                  ),
                )),
            // validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'certificate_expiration_date_to',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            readOnly: true,
            onTap: () {

            },
            decoration: InputDecoration(
                hintText: "select_date".tr(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    IconPath.calendar,
                  ),
                )),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'phoneNumber',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "phoneNumberFieldHint".tr(),
            ),
            validator: (text) =>
                (text == null || text.isEmpty /* || vild if add phone */)
                    ? null
                    : "null",
          ),
        ),
        ////////////////////////////
        const SizedBox(height: 12),
        TitleWithWidget(
          title: 'service',
          widget: DropdownMenu<String>(
            //initialSelection: menuItems.first,
            // controller: menuController,
            width: double.maxFinite,
            expandedInsets: EdgeInsets.zero,
            hintText: "select_service".tr(),
            requestFocusOnTap: true,
            enableFilter: true,
            trailingIcon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            onSelected: (String? menu) {},
            dropdownMenuEntries: ["menuItems", "String", "test"]
                .map<DropdownMenuEntry<String>>((String menu) {
              return DropdownMenuEntry<String>(
                value: menu,
                label: menu,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
