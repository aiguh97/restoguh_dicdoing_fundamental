import 'package:flutter/material.dart';
import '../../../models/restaurant_detail.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header "Kategori"
        Text(
          "Kategori :",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((c) {
            return Chip(
              label: Text(
                c.name,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme
                      .onPrimary, // teks menyesuaikan background chip
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.primary, width: 1),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
