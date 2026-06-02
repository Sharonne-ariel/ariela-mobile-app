/// Role of a chat message — used by both UI and the OpenAI API.
enum ChatRole { user, assistant, system }

/// A single message in an AI conversation.
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.createdAt,
  });

  final ChatRole role;
  final String content;
  final DateTime? createdAt;

  Map<String, dynamic> toApi() => {
        'role': role.name,
        'content': content,
      };

  factory ChatMessage.fromRow(Map<String, dynamic> row) {
    final roleStr = row['role'] as String? ?? 'user';
    return ChatMessage(
      role: ChatRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => ChatRole.user,
      ),
      content: row['content'] as String? ?? '',
      createdAt: row['created_at'] is String
          ? DateTime.tryParse(row['created_at'] as String)
          : null,
    );
  }
}