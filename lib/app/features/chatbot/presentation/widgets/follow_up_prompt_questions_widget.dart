import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/prompt_questions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FollowUpPromptQuestionsWidget extends StatelessWidget {
  const FollowUpPromptQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBotProvider chatBotProvider = context.watch<ChatBotProvider?>()!;

    return Consumer<PromptQuestionsProvider>(
      builder: (context, provider, _) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          mainAxisAlignment: MainAxisAlignment.end ,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: provider.listQuestionsFollowUp.map(
                  (question) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                      child: InkWell(
                        onTap: () {
                          chatBotProvider.countFullUpQuestions.value = 0;
                          chatBotProvider.sendQuestion(question);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // color: AppColor.primary600Light,
                            border: Border.all(
                              color: AppColor.primary600Light,
                              width: 2,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            question,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 5,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
      },
    );
  }
}
