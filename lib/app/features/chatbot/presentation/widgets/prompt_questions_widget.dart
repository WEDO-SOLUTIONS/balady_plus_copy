import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/prompt_questions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PromptQuestionsWidget extends StatelessWidget {
  const PromptQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBotProvider chatBotProvider = context.watch<ChatBotProvider?>()!;
    return ValueListenableBuilder<List>(
      valueListenable: chatBotProvider.chatBotMessage,
      builder: (_, listMessages, child) {
        return listMessages.isEmpty
            ? Consumer<PromptQuestionsProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 90,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: provider.listQuestions.map(
                              (question) {
                                return InkWell(
                                  onTap: () => chatBotProvider.sendQuestion(question),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            question,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            maxLines: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                },
              )
            : const SizedBox();
      },
    );
  }
}
