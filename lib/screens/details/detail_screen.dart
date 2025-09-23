import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/widgets/detail_add_review.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/category_list.dart';
import '../../services/api_service.dart';
import '../../models/restaurant_detail.dart';
import 'widgets/detail_appbar.dart';
import 'widgets/detail_header.dart';
import 'widgets/menu_list.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<RestaurantDetail> _future;
  bool _showAppbarTitle = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _reviewsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchRestaurantDetail(widget.id);
  }

  void _refreshData() {
    setState(() {
      _future = ApiService.fetchRestaurantDetail(widget.id);
    });
  }

  void _scrollToReviews() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_reviewsSectionKey.currentContext != null) {
        Scrollable.ensureVisible(
          _reviewsSectionKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showAddReviewPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReviewPopup(restaurantId: widget.id),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReviewPopup,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_comment),
      ),
      body: FutureBuilder<RestaurantDetail>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/no_internet.png", width: 250),
                  const SizedBox(height: 16),
                  const Text(
                    'Koneksi Terputus',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Refresh'),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      // snap.error.toString(),
                      "Periksa jaringan internet anda",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snap.hasData || snap.data == null) {
            return const Center(child: Text('No data'));
          }

          final r = snap.data!;
          // sisanya tetap → NotificationListener + CustomScrollView
          return NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.axis == Axis.vertical) {
                if (scroll.metrics.pixels > 120 && !_showAppbarTitle) {
                  setState(() => _showAppbarTitle = true);
                } else if (scroll.metrics.pixels <= 120 && _showAppbarTitle) {
                  setState(() => _showAppbarTitle = false);
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                DetailAppbar(r: r, showAppbarTitle: _showAppbarTitle),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailHeader(r: r, onShowReviews: _scrollToReviews),
                        const SizedBox(height: 16),
                        CategoryList(categories: r.categories),
                        const SizedBox(height: 16),
                        MenuList(
                          title: "Makanan",
                          items: r.foods,
                          imagePath: "assets/images/makanan.png",
                        ),
                        const SizedBox(height: 16),
                        MenuList(
                          title: "Minuman",
                          items: r.drinks,
                          imagePath: "assets/images/minuman.png",
                        ),
                        const SizedBox(height: 16),
                        _buildReviewsSection(r.customerReviews),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsSection(List<CustomerReview> reviews) {
    final sortedReviews = _sortReviewsByDateDescending(reviews);

    return KeyedSubtree(
      key: _reviewsSectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              IconButton(
                icon: Icon(
                  Icons.add_comment,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _showAddReviewPopup,
                tooltip: 'Tambah Ulasan',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (sortedReviews.isEmpty)
            _buildEmptyReviews()
          else
            Column(
              children: sortedReviews
                  .map((review) => _buildReviewItem(review))
                  .toList(),
            ),
        ],
      ),
    );
  }

  List<CustomerReview> _sortReviewsByDateDescending(
    List<CustomerReview> reviews,
  ) {
    final sorted = List<CustomerReview>.from(reviews);
    sorted.sort((a, b) {
      try {
        final dateA = _parseReviewDate(a.date);
        final dateB = _parseReviewDate(b.date);
        return dateB.compareTo(dateA);
      } catch (_) {
        return 0;
      }
    });
    return sorted;
  }

  DateTime _parseReviewDate(String dateString) {
    final monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
      'Januari': 1,
      'Februari': 2,
      'Maret': 3,
      'April': 4,
      'Mei': 5,
      'Juni': 6,
      'Juli': 7,
      'Agustus': 8,
      'September': 9,
      'Oktober': 10,
      'November': 11,
      'Desember': 12,
    };

    try {
      final parts = dateString.split(' ');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = monthMap[parts[1]] ?? DateTime.now().month;
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;
        return DateTime(year, month, day);
      }
      return DateTime.parse(dateString);
    } catch (_) {
      return DateTime(1970);
    }
  }

  Widget _buildEmptyReviews() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.reviews_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            'Belum ada ulasan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jadilah yang pertama memberikan ulasan!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showAddReviewPopup,
            child: const Text('Tambah Ulasan Pertama'),
          ),
        ],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
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

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
    ];
    final index = name.isEmpty
        ? 0
        : name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }
}
