import 'package:flutter/material.dart';

import '../../../../models/restaurant_detail.dart';

class ReviewList extends StatefulWidget {
  final List<CustomerReview> sortedReviews;

  const ReviewList({super.key, required this.sortedReviews});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final ScrollController _scrollController = ScrollController();
  int _itemsToShow = 2; // awalnya 2 item

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // ketika scroll mendekati bawah
        _loadMore();
      }
    });
  }

  void _loadMore() {
    if (_itemsToShow < widget.sortedReviews.length) {
      setState(() {
        _itemsToShow += 2; // tambah 2 item lagi
        if (_itemsToShow > widget.sortedReviews.length) {
          _itemsToShow = widget.sortedReviews.length;
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _itemsToShow,
      itemBuilder: (context, index) {
        final review = widget.sortedReviews[index];
        return _buildReviewItem(review);
      },
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
                            fontFamily: 'Geometr415',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Review Text
                    Text(
                      review.review,
                      style: const TextStyle(
                        fontFamily: 'Geometr415',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dummy method, ganti dengan implementasi asli
  Color _getAvatarColor(String name) {
    return Colors.blue;
  }
}
