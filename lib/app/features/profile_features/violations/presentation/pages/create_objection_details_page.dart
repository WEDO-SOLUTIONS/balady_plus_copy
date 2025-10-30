import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/vd_exports.dart';
import '../create_objection_bloc/create_objection_bloc.dart';
import '../widgets/create_objection_page/add_reason_widget.dart';
import '../widgets/create_objection_page/objection_previous_next_buttons.dart';
import '../widgets/create_objection_page/reply_attachment_section.dart';

class CreateObjectionDetailsPage extends StatefulWidget {
  const CreateObjectionDetailsPage({super.key});

  @override
  State<CreateObjectionDetailsPage> createState() =>
      _CreateObjectionDetailsPageState();
}

class _CreateObjectionDetailsPageState
    extends State<CreateObjectionDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateObjectionBloc, CreateObjectionState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VdHeaderDesc(
                      header: ("objection_details_objections_list").tr(),
                    ),
                    //    NotesFieldsSection(initialDesc: state.notes),
                    ReplyAttachmentSection(),
                    AddReasonWidget(),
                    CustomVerticalSpace(height: 100),
                    //  SubmitBtn(),
                  ],
                ),
              ),
            ),
          ),
          ObjectionsNextButtons()
        ],
      );
    });
  }
}
