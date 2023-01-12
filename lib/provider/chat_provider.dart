import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/chat_message_model.dart';

final chatNotifierProvider = ChangeNotifierProvider(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends ChangeNotifier {
  final List<ChatMessageModel> messages = [];

  clearMessages() {
    messages.clear();
    notifyListeners();
  }
}
