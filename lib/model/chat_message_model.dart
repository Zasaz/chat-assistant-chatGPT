enum ChatMessageType { user, bot }

class ChatMessageModel {
  String? text;
  ChatMessageType? type;

  ChatMessageModel({
    required this.text,
    required this.type,
  });
}
