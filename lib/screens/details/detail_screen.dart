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
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _future = ApiService.fetchRestaurantDetail(widget.id);
    });
  }

  void _scrollToReviews() {
    // Delay sedikit untuk memastikan widget sudah ter-render
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
      builder: (context) {
        return AddReviewPopup(
          restaurantId: widget.id,
          onReviewAdded: _refreshData,
        );
      },
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
        child: const Icon(Icons.add_comment),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<RestaurantDetail>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          } else if (!snap.hasData) {
            return const Center(child: Text('No data'));
          }

          final r = snap.data!;
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
                        DetailHeader(
                          r: r,
                          onShowReviews:
                              _scrollToReviews, // ✅ Sekarang berfungsi
                        ),
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

                        // ✅ REVIEWS SECTION DENGAN KEY UNTUK SCROLL
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
    // ✅ SORT REVIEWS TERBALIK (TERBARU -> TERLAMA)
    final sortedReviews = _sortReviewsByDateDescending(reviews);

    return KeyedSubtree(
      key: _reviewsSectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan button tambah review
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

          // List Reviews dengan sorting terbalik
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

  // ✅ METHOD UNTUK SORTING REVIEWS BERDASARKAN TANGGAL (TERBARU PERTAMA)
  List<CustomerReview> _sortReviewsByDateDescending(
    List<CustomerReview> reviews,
  ) {
    // Buat copy dari list untuk menghindari modifikasi original
    final sorted = List<CustomerReview>.from(reviews);

    sorted.sort((a, b) {
      try {
        // Parse tanggal dari format "13 November 2019"
        final dateA = _parseReviewDate(a.date);
        final dateB = _parseReviewDate(b.date);

        // Sort descending (terbaru -> terlama)
        return dateB.compareTo(dateA);
      } catch (e) {
        // Jika parsing gagal, pertahankan urutan asli
        return 0;
      }
    });

    return sorted;
  }

  // ✅ METHOD UNTUK PARSE TANGGAL DARI STRING
  DateTime _parseReviewDate(String dateString) {
    try {
      // Coba berbagai format tanggal yang mungkin
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

      final parts = dateString.split(' ');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final monthName = parts[1];
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;

        final month = monthMap[monthName] ?? DateTime.now().month;

        return DateTime(year, month, day);
      }

      // Fallback: coba parsing dengan DateTime.parse
      return DateTime.parse(dateString);
    } catch (e) {
      // Jika semua parsing gagal, kembalikan tanggal sangat lama
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
          Icon(
            Icons.reviews_outlined,
            size: 48,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada ulasan',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama memberikan ulasan!',
            style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 12),
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
