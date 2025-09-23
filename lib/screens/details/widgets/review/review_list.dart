import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/review_list_provider.dart';
import '../../../../models/restaurant_detail.dart';

class ReviewList extends StatelessWidget {
  final List<CustomerReview> sortedReviews;

  const ReviewList({super.key, required this.sortedReviews});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewListProvider(),
      child: Consumer<ReviewListProvider>(
        builder: (context, provider, _) {
          final itemsToShow = provider.itemsToShow;

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 100) {
                provider.loadMore(sortedReviews.length);
              }
              return false;
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: itemsToShow,
              itemBuilder: (context, index) {
                final review = sortedReviews[index];
                return _buildReviewItem(review);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewItem(CustomerReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Date
                    Row(
                      children: [
                        Text(
                          review.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          review.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Review Text
                    Text(review.review, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dummy method, ganti sesuai implementasi asli
  Color _getAvatarColor(String name) {
    return Colors.blue;
  }
}
