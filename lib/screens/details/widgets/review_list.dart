import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/restaurant_detail.dart';

class ReviewList extends StatelessWidget {
  final List<CustomerReview> reviews;
  final VoidCallback? onShowAll;

  const ReviewList({super.key, required this.reviews, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    // Ambil 3 review terbaru untuk preview
    final previewReviews = reviews.length > 3 ? reviews.sublist(0, 3) : reviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Text(
              'Ulasan Pelanggan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${reviews.length} ulasan',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            if (reviews.length > 3)
              TextButton(
                onPressed: onShowAll,
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Reviews List
        if (previewReviews.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: [
              ...previewReviews.map(
                (review) => _buildReviewItem(context, review),
              ),
              if (reviews.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton(
                    onPressed: onShowAll,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat ${reviews.length - 3} ulasan lainnya',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.reviews_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Belum ada ulasan',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama memberikan ulasan!',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, CustomerReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getAvatarColor(review.name),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                review.name.isNotEmpty ? review.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Review Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                  // ignore: deprecated_member_use
                ).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Date Row
                  Row(
                    children: [
                      Text(
                        review.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(review.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Review Text
                  Text(
                    review.review,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
      Colors.teal.shade600,
      Colors.pink.shade600,
      Colors.indigo.shade600,
    ];
    final index = name.isEmpty
        ? 0
        : name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }

  String _formatDate(String dateString) {
    try {
      // Coba parsing berbagai format tanggal
      final formats = [
        DateFormat("dd MMMM yyyy", "id_ID"),
        DateFormat("MMMM dd, yyyy", "en_US"),
        DateFormat("yyyy-MM-dd"),
      ];

      for (final format in formats) {
        try {
          final date = format.parse(dateString);
          return DateFormat("dd MMM yyyy", "id_ID").format(date);
        } catch (_) {
          continue;
        }
      }

      // Jika parsing gagal, kembalikan string asli
      return dateString;
    } catch (_) {
      return dateString;
    }
  }
}
