import 'package:flutter/material.dart';
import '../../../models/restaurant_detail.dart';

class MenuList extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String imagePath; // ✅ path gambar dummy

  const MenuList({
    super.key,
    required this.title,
    required this.items,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'GillSansMT',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: items.map((item) => _menuCard(item.name)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _menuCard(String title) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    imagePath, // ✅ gambar sesuai parameter
                    fit: BoxFit.contain,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
