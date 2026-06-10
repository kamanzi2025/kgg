import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../models/chat_message_model.dart';
import '../../providers/app_provider.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final rooms = provider.chatRooms;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chats',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
            ),

            // Chat rooms list
            Expanded(
              child: rooms.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversations yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: rooms.length,
                      itemBuilder: (_, i) => _ChatRoomTile(room: rooms[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoom room;
  const _ChatRoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    final last = room.lastMessage;
    final unread = room.unreadCount;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.chatRoom, arguments: room.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unread > 0 ? AppColors.accentGold.withAlpha(60) : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: room.coverImageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        Container(color: AppColors.cardBackgroundLight),
                    errorWidget: (_, _, _) => Container(
                      width: 52,
                      height: 52,
                      color: AppColors.cardBackgroundLight,
                      child: const Icon(Icons.group_rounded,
                          color: AppColors.textSecondary),
                    ),
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: unread > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (last != null)
                        Text(
                          timeago.format(last.timestamp, allowFromNow: true),
                          style: TextStyle(
                            color: unread > 0
                                ? AppColors.accentGold
                                : AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (last != null)
                    Row(
                      children: [
                        Text(
                          '${last.senderName.split(' ').first}: ',
                          style: const TextStyle(
                            color: AppColors.accentGold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            last.content,
                            style: TextStyle(
                              color: unread > 0
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
