import 'package:flutter/material.dart';

class RepairCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color iconColor;
  final bool isEmergency;
  final VoidCallback onPressed;

  const RepairCard( {
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.iconColor,
    required this.isEmergency,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: 8),

          // Заголовок
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: isEmergency ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),

          // Описание
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isEmergency ? Colors.white70 : Colors.black54,
            ),
          ),
          const Spacer(),

          // Кнопка — разная для аварийной и обычной
          isEmergency
              ? SizedBox(
                  width: double.infinity, // на всю ширину
                  height: 40, // делаем крупной
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Связаться ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity, // на всю ширину
                  height: 40, // делаем крупной
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 60, 53, 53),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: const Text('Подать заявку'),
                  ),
                ),
        ],
      ),
    );
  }
}
