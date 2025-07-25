class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final ChatMessageType type;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.type = ChatMessageType.text,
    this.metadata,
  });
}

enum ChatMessageType {
  text,
  quickReply,
  image,
  appointment,
  emergency,
}

class QuickReply {
  final String id;
  final String text;
  final String action;

  QuickReply({
    required this.id,
    required this.text,
    required this.action,
  });
}

class FAQ {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final String category;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.category,
  });
}
