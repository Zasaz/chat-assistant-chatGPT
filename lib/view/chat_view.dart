import 'dart:developer';

import 'package:chat_bot/model/chat_message_model.dart';
import 'package:chat_bot/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  String text = 'Hold the button and start speaking';
  final TextEditingController _queryController = TextEditingController();
  bool isListening = false;
  bool isSendButton = false;

  SpeechToText speechToText = SpeechToText();
  final List<ChatMessageModel> message = [];
  var scrollController = ScrollController();

  scrollHandler() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    itemCount: message.length,
                    itemBuilder: (context, index) => chatBubble(
                      text: message[index].text.toString(),
                      type: message[index].type,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _queryController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isSendButton = true;
                          });
                        } else {
                          setState(() {
                            isSendButton = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
                    onTapDown: (value) async {
                      if (!isListening && !isSendButton) {
                        bool isAvailable = await speechToText.initialize();
                        if (isAvailable) {
                          setState(() {
                            isListening = true;
                            speechToText.listen(
                              onResult: (result) {
                                setState(() {
                                  text = result.recognizedWords;
                                });
                              },
                            );
                          });
                        }
                        log('Tap down');
                      }
                    },
                    onTapUp: (value) async {
                      if (!isSendButton) {
                        setState(() {
                          isListening = false;
                        });
                        speechToText.stop();
                        message.add(
                          ChatMessageModel(
                              text: text, type: ChatMessageType.user),
                        );
                        var msg = await ChatRepository().sendMessage(text);
                        setState(() {
                          message.add(
                            ChatMessageModel(
                                text: msg, type: ChatMessageType.bot),
                          );
                        });
                        log('Tap up');
                      }
                    },
                    onTap: () async {
                      if (isSendButton == true &&
                          _queryController.text.isNotEmpty) {
                        message.add(
                          ChatMessageModel(
                              text: _queryController.text,
                              type: ChatMessageType.user),
                        );
                        var msg = await ChatRepository()
                            .sendMessage(_queryController.text)
                            .then((val) {
                          _queryController.clear();
                        });
                        setState(() {
                          message.add(
                            ChatMessageModel(
                                text: msg, type: ChatMessageType.bot),
                          );
                        });
                        log('Sending');
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        isSendButton ? Icons.send : Icons.mic,
                        color: Colors.white,
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
          radius: 20,
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
                  type.index == 0 ? Colors.teal.shade100 : Colors.grey.shade200,
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
                  fontWeight:
                      type.index == 0 ? FontWeight.w500 : FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
