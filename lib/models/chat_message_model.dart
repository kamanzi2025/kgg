class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatRoom {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final List<String> memberIds;
  final List<ChatMessageModel> messages;
  final String communityId;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.memberIds,
    required this.messages,
    required this.communityId,
  });

  ChatMessageModel? get lastMessage =>
      messages.isEmpty ? null : messages.last;

  int get unreadCount => messages.where((m) => !m.isRead).length;
}
