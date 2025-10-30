import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart' show trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_field_widget.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/rating/rating_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTextFieldWidget extends StatefulWidget {
  const CommentTextFieldWidget({Key? key}) : super(key: key);

  @override
  State<CommentTextFieldWidget> createState() => _CommentTextFieldWidgetState();
}

class _CommentTextFieldWidgetState extends State<CommentTextFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(16),
          child: CustomTextFieldWidget(
            label: trans('optional_comment'),
            hintText: trans('optional_comment_hint'),
            controller: _controller,
            maxLines: 4,
            contentVerticalPadding: 10,
            spacerSize: 0,
            onChanged: (String text) {
              context.read<RatingBloc>().add(ChangeRatingComment(text: text));
            },
            validator: (_) {},
          ),
        );
      },
    );
  }
}
