import 'package:flutter/material.dart';
import 'package:dom_vmeste/data/models/repair_models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestCard extends StatelessWidget {
  final RepairRequestModel request;
  final VoidCallback onDelete;

  const RequestCard({
    
    super.key,
    required this.request,
    required this.onDelete,
  });

IconData _getIcon(String type) {
  
  final t = type.trim().toLowerCase();

  if (t.contains('сантех')) {
    return FontAwesomeIcons.wrench;
  } else if (t.contains('электр')) {
    return FontAwesomeIcons.plug;
  } else if (t.contains('общ')) {
    return FontAwesomeIcons.building;
  } else {
    return Icons.build;
  }
}
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка типа заявки
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIcon(request.repairType),
              color: Colors.blue,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),

          // Информация о заявке
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.repairType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 4),
                
                Text(
                  'Описание проблемы: ${request.description}',
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (request.date.isNotEmpty)
                  Text(
                    'Время: ${request.date}, ${request.timeFrom}-${request.timeTo}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
               
              ],
            ),
          ),

          // Кнопка удалить
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Удалить заявку?'),
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
    );
  }
}