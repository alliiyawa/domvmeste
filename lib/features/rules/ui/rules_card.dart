import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RuleCard extends StatelessWidget {
  final String imagePath; 
  final String title;
  final String subtitle;
  final Color color;
  

  const RuleCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.color, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Иконка
          Container(
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: color.withOpacity(0.15),
    shape: BoxShape.circle,
  ),
  child: imagePath.endsWith('.svg')
      ? SvgPicture.asset(
          imagePath,
          width: 50,
          height: 50,
        )
      : Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
),

          SizedBox(width: 16),

          // Текст
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15) , 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}