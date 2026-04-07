import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String phone;
  final String price;
  final String imageUrl;

  const AnnouncementDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.phone,
    required this.price,
    required this.imageUrl,
  });

  Future<void> _callPhone() async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    print('IMAGE URL: $imageUrl');
    return Scaffold(
      appBar: AppBar(title: const Text('Объявление')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey[400],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),

            const SizedBox(height: 16),

            // Дата
            Text(date, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 8),

            // Заголовок
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Описание
            Text(description, style: textTheme.bodyMedium),

            const SizedBox(height: 24),

            // Контакт
            if (phone.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text('Контакт', style: textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                phone,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Цена + кнопка
            if (price.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text('Цена', style: textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                price,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _callPhone,
                  icon: const Icon(Icons.phone),
                  label: const Text('Позвонить'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
