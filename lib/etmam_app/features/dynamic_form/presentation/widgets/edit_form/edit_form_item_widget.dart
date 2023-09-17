import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    hide DropDownItem;
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/edit_bidding_form/edit_bidding_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../core/utils/enums/dynamic_forms.dart';

class EditFormItemWidget extends StatefulWidget {
  final CreateFormItemResponse form;

  const EditFormItemWidget({super.key, required this.form});

  @override
  State<EditFormItemWidget> createState() => _EditFormItemWidgetState();
}

class _EditFormItemWidgetState extends State<EditFormItemWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EdtiBiddingFormBloc, EditBiddingFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomVerticalSpace(height: 16),
                CustomTextWidget(widget.form.serviceName ?? "",
                    fontColor: AppColor.black,
                    fontSize: 22,
                    fontWeight: AppFontWeight.bold),
                CustomVerticalSpace(height: 16),
                ListView.builder(
                    itemCount: widget.form.items?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      if (widget.form.items?[index].getComponentType() ==
                          DynamicFormComponentType.hidden) return SizedBox();
                      if (widget.form.items?[index].getComponentType() ==
                          DynamicFormComponentType.text)
                        return DynamicFormTextField(
                          errors: widget.form.items?[index].errors?.errorsStr,
                          initialValue: widget.form.items?[index].value,
                          key: ValueKey(widget.form.items?[index].field?.id),
                          label: widget.form.items?[index].fieldLabel ?? "",
                          isReadOnly:
                              widget.form.items?[index].fieldReadOnly ?? false,
                          isRequired:
                              widget.form.items?[index].fieldRequired ?? false,
                          type: widget.form.items?[index].getFieldDataType(),
                          onChanged: (String? text) {
                            context.read<EdtiBiddingFormBloc>().add(
                                ChangeTextComponentEvent(
                                    fieldId:
                                        widget.form.items![index].field!.id!,
                                    text: text));
                          },
                        );
                      if (widget.form.items?[index].getComponentType() ==
                          DynamicFormComponentType.dropDown)
                        return DynamicFormDropDownField(
                          label: widget.form.items?[index].fieldLabel ?? "",
                          errors: widget.form.items?[index].errors?.errorsStr,
                          isReadOnly:
                              widget.form.items?[index].fieldReadOnly ?? false,
                          isRequired:
                              widget.form.items?[index].fieldRequired ?? false,
                          items: widget.form.items?[index].dataItems ?? [],
                          currentItem:
                              widget.form.items?[index].selectedDataItem,
                          onChanged: (DropDownItem? item) {
                            if (item != null)
                              context.read<EdtiBiddingFormBloc>().add(
                                  SelectFormFieldDataEvent(
                                      fieldId:
                                          widget.form.items?[index].field?.id,
                                      item: item));
                          },
                          onEmptyList: () async {
                            return await context
                                .read<EdtiBiddingFormBloc>()
                                .getDataEventHandler(GetFormFieldDataEvent(
                                    fieldId:
                                        widget.form.items?[index].field?.id));
                          },
                        );
                      return Container(child: Text("No Element"));
                    }),
                CustomVerticalSpace(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}
