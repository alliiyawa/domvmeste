import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dom_vmeste/data/models/lost_model.dart';

class LostCard extends StatelessWidget {
  final LostModel item;
  final VoidCallback onDelete;

  const LostCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  Future<void> _callPhone() async {
  final uri = Uri.parse('tel:${item.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Верхняя часть: фото + инфо ──────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Фото
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrl.isNotEmpty &&
                        item.imageUrl.startsWith('http')
                    ? Image.network(
                        item.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),

              // Заголовок, дата, описание
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Стрелка вправо
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(item.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Нижняя часть: автор + кнопка ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Автор и телефон
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Автор: ',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          item.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    
                      Text(
                        item.phone,
                        style: const TextStyle(fontSize: 13),  
                      ),
                    
                  ],
                ),
              ),

              // Кнопка позвонить
              ElevatedButton.icon(
                onPressed: _callPhone,
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Позвонить'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                onDelete(); // ← обязательно !
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
        ],
      ),
    );
  }
}