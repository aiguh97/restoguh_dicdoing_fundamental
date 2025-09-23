// lib/screens/details/widgets/category_list.dart
import 'package:flutter/material.dart';
import '../../../models/restaurant_detail.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori :",
          style: TextStyle(
            fontFamily: 'GillSansMT',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((c) {
            return Chip(
              label: Text(
                c.name,
                style: TextStyle(
                  fontFamily: 'Geometr415',
                  color: Colors
                      .white, // teks putih supaya terlihat di background hijau
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
