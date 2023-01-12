import 'package:chat_bot/core/constants/three_dots.dart';
import 'package:chat_bot/model/chat_message_model.dart';
import 'package:chat_bot/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../provider/chat_response_provider.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController _queryController = TextEditingController();
  bool isListening = false;
  bool isSendButton = false;
  ChatRepository? chatRepo;

  SpeechToText speechToText = SpeechToText();
  final List<ChatMessageModel> message = [];
  var scrollController = ScrollController();

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade300,
        elevation: 0,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: message.length,
                      itemBuilder: (context, index) {
                        return chatBubble(
                          text: message[index].text.toString(),
                          type: message[index].type,
                        );
                      }),
                ),
              ),
              chatRepo!.isLoading ? const ThreeDots() : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _queryController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red.shade100),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: InputBorder.none,
                        hintText: 'Type your query',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      if (_queryController.text.isNotEmpty) {
                        message.add(
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
                          setState(() {
                            message.add(
                              ChatMessageModel(
                                  text: value.toString(),
                                  type: ChatMessageType.bot),
                            );
                          });
                          scrollHandler();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            dismissDirection: DismissDirection.horizontal,
                            margin: const EdgeInsets.all(20),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red.shade300,
                            content: const Text('Query cannot be empty'),
                          ),
                        );
                      }
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.teal,
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
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
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: type.index == 0 ? FontWeight.w500 : FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
