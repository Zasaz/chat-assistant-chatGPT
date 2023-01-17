import 'package:chat_bot/core/constants/app_utils.dart';
import 'package:chat_bot/core/constants/three_dots.dart';
import 'package:chat_bot/model/chat_message_model.dart';
import 'package:chat_bot/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/chat_provider.dart';
import '../provider/chat_response_provider.dart';

class ChatGPTView extends ConsumerStatefulWidget {
  const ChatGPTView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatGPTView> {
  final TextEditingController _queryController = TextEditingController();
  var scrollController = ScrollController();
  ChatRepository? chatRepo;

  scrollHandler() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    chatRepo = ref.watch(chatRepositoryProvider);
    final chatNotifier = ref.watch(chatNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade400,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                await chatNotifier.clearMessages();
                _queryController.clear();
                if (!mounted) return;
                AppUtils().showScaffoldMessenger(
                  'Chat cleared. New ChatGPT link established',
                  Colors.green.shade300,
                  context,
                );
              },
              icon: const Icon(Icons.clear_all),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    itemCount: chatNotifier.messages.length,
                    itemBuilder: (context, index) => chatBubble(
                      text: chatNotifier.messages[index].text.toString(),
                      type: chatNotifier.messages[index].type,
                    ),
                  ),
                ),
              ),
              chatRepo!.isLoading ? const ThreeDots() : const SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _queryController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red.shade100),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: InputBorder.none,
                        hintText: 'Type your query',
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      if (chatRepo!.isLoading == true) {
                        AppUtils().showScaffoldMessenger(
                          'Request already sent',
                          Colors.blue.shade300,
                          context,
                        );
                      } else if (_queryController.text.isNotEmpty) {
                        chatNotifier.messages.add(
                          ChatMessageModel(
                              text: _queryController.text,
                              type: ChatMessageType.user),
                        );
                        await chatRepo!
                            .sendMessage(
                          _queryController.text.toString(),
                        )
                            .then((value) {
                          _queryController.clear();
                          chatNotifier.messages.add(
                            ChatMessageModel(
                                text: value.toString(),
                                type: ChatMessageType.bot),
                          );
                          scrollHandler();
                        });
                        _queryController.clear();
                      } else {
                        AppUtils().showScaffoldMessenger(
                          'Query cannot be empty',
                          Colors.red.shade300,
                          context,
                        );
                      }
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.teal,
                      child: Center(
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble({required String text, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          child: Icon(
            type!.index == 0 ? Icons.person : Icons.auto_awesome,
            color: Colors.black,
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color:
                  type.index == 0 ? Colors.teal.shade50 : Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: type.index == 0 ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
