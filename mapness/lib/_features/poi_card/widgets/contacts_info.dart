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
  final PoiCardViewModel viewModel;
  final DirectoryObjectMessage data;

  const ContactsInfo({
    super.key,
    required this.viewModel,
    required this.data,
  });

  @override
  State<ContactsInfo> createState() => _ContactsInfoState();
}

class _ContactsInfoState extends State<ContactsInfo> {
  late List<Widget> contactInfoWidgets;

  @override
  void initState() {
    contactInfoWidgets = prepareWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          ));
  }

  List<Widget> prepareWidgets() {
    return widget.data.getContactsInfoModels().map((contactsModel) {
      return GestureDetector(
        onTap: () {
          var value = contactsModel.value;
          if (value != null) {
            switch (contactsModel.type) {
              case ContactsInfoType.phone:
                widget.viewModel.callPhone(data: widget.data);
              case ContactsInfoType.email:
                widget.viewModel.sendEmail(value);
              default:
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
                color: colorAccent,
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: buildText(
                          text: contactsModel.displayText,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: colorPrimary,
                          maxLines: 1),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: buildText(
                        maxLines: 1,
                        text: contactsModel.comment,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorPrimary.withOpacity(.5),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }).toList();
  }
}
