import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_config.dart';

class ContactsInfo extends StatefulWidget {
  const ContactsInfo({
    required this.viewModel,
    required this.data,
    super.key,
  });
  final PoiCardViewModel viewModel;
  final DirectoryObjectMessage data;

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  @override
  Widget build(BuildContext context) {
    final contactInfoWidgets = prepareWidgets();

    return contactInfoWidgets.isEmpty
        ? const SizedBox.shrink()
        : CardContent(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, i) => contactInfoWidgets[i],
              separatorBuilder: (ctx, index) => const Divider(indent: 24),
              itemCount: contactInfoWidgets.length,
            ),
          );
  }

  List<Widget> prepareWidgets() => widget.data.getContactsInfoModels().map((contactsModel) {
        final text = contactsModel.displayText;
        var displayText = text;
        if (contactsModel.type == ContactsInfoType.website) {
          if (text != null) {
            displayText = RegExp('^(?:https?://)?(?:ftp://)?(?:www.)?([^/]+)').stringMatch(text);
          }
        }

        return GestureDetector(
          onTap: () {
            final value = contactsModel.value;
            if (value != null) {
              if (contactsModel.type == ContactsInfoType.phone) {
                widget.viewModel.callPhone(data: widget.data);
              } else if (contactsModel.type == ContactsInfoType.email) {
                widget.viewModel.sendEmail(value);
              } else {
                widget.viewModel.launch(value);
              }
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SvgPicture.asset(
                  contactsModel.type.getIconResource(),
                  package: PackageConfig.packageName,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.color.strokeAccent, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: StyleText(
                          text: displayText,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: context.color.textAndIconsBasePrimary,
                          maxLines: 1,
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: StyleText(
                          maxLines: 1,
                          text: contactsModel.comment,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.color.textAndIconsBasePrimary.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();
}
