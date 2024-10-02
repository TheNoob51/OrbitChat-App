class GeminiMessage {
  final bool isUser;
  final String message;
  final DateTime time;

  GeminiMessage({
    required this.isUser,
    required this.message,
    required this.time,
  });

  // factory GeminiMessage.fromJson(Map<String, dynamic> json) {
  //   return GeminiMessage(
  //     id: json['id'],
  //     content: json['content'],
  //     timestamp: DateTime.parse(json['timestamp']),
  //     sender: json['sender'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'content': content,
  //     'timestamp': timestamp.toIso8601String(),
  //     'sender': sender,
  //   };
  // }
}
