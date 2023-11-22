import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../core/utils/enums/dynamic_forms.dart';
import '../../../../dynamic_form/domain/entities/create_form_item_response.dart';
import '../../../../dynamic_form/presentation/widgets/dynamic_form_drop_down_field.dart';
import '../../../../dynamic_form/presentation/widgets/dynamic_form_text_field.dart';
import '../../blocs/submit_request/bloc/submit_request_bloc.dart';

class DelgateFormItemWidget extends StatefulWidget {
  final CreateFormItemResponse form;

  const DelgateFormItemWidget({super.key, required this.form});

  @override
  State<DelgateFormItemWidget> createState() => _DelgateFormItemWidgetState();
}

class _DelgateFormItemWidgetState extends State<DelgateFormItemWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitRequestBloc, SubmitRequestState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        key: ValueKey(widget.form.items?[index].field?.id),
                        label: widget.form.items?[index].fieldLabel ?? "",
                        isReadOnly:
                            widget.form.items?[index].fieldReadOnly ?? false,
                        isRequired:
                            widget.form.items?[index].fieldRequired ?? false,
                        type: widget.form.items?[index].getFieldDataType(),
                        onChanged: (String? text) {
                          context.read<SubmitRequestBloc>().add(
                              ChangeTextComponentEvent(
                                  fieldId: widget.form.items![index].field!.id!,
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
                        currentItem: widget.form.items?[index].selectedDataItem,
                        onChanged: (DropDownItem? item) {
                          if (item != null)
                            context.read<SubmitRequestBloc>().add(
                                SelectFormFieldDataEvent(
                                    fieldId:
                                        widget.form.items?[index].field?.id,
                                    item: item));
                        },
                        onEmptyList: () async {
                          return await context
                              .read<SubmitRequestBloc>()
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
        );
      },
    );
  }
}
