import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dom_vmeste/data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  Color _getCategoryColor() {
    switch (notification.category) {
      case 'news': return Colors.blue;
      case 'announcements': return Colors.orange;
      case 'repair': return Colors.green;
      case 'lost': return Colors.purple;
      case 'rules': return Colors.teal;
      default: return Colors.blue[300]!;
    }
  }

  IconData _getCategoryIcon() {
    switch (notification.category) {
      case 'news': return Icons.notifications_outlined;
      case 'announcements': return Icons.campaign_outlined;
      case 'repair': return Icons.build_outlined;
      case 'lost': return Icons.search_outlined;
      case 'rules': return Icons.rule_outlined;
      default: return Icons.notifications_outlined;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (diff.inDays == 1) {
      return 'Вчера';
    } else {
      return DateFormat('dd MMM', 'ru').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Иконка категории ──────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // ── Текст ─────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок + точка + время
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Синяя точка — непрочитанное
                            if (!notification.isRead) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Описание
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Звёздочка — важное ────────────────────────
            if (notification.isImportant)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.amber[600],
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}