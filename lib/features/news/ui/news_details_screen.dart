import 'package:flutter/material.dart';


class NewsDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String imageUrl;

  const NewsDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold( backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(title: const Text('Новость', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),  backgroundColor: const Color(0xFFF2F5FA),),
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
          ],
        ),
      ),
    );
  }
}
