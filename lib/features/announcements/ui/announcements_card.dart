import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';

class AnnouncementsCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String date;
  final String phone;
  final String price;
  final String? imageUrl;
  final VoidCallback onDelete;

  const AnnouncementsCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.phone,
    required this.price,
    required this.onDelete,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        RouteNames.announcementDetail,
        extra: {
          'title': title,
          'description': description,
          'date': date,
          'phone': phone,
          'price': price,
          'imageUrl': imageUrl ?? '',
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null && imageUrl!.startsWith('http')
                  ? Image.network(
                      imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(width: 80, height: 80, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Удалить объявление?'),
                    content: const Text('Это действие нельзя отменить.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onDelete();
                        },
                        child: const Text(
                          'Удалить',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
