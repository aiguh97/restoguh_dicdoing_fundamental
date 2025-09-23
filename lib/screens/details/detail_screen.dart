import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/widgets/detail_add_review.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/widgets/review/review_list.dart';
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
  
  // Variabel untuk infinite scroll
  List<CustomerReview> _allReviews = [];
  List<CustomerReview> _displayedReviews = [];
  int _currentIndex = 0;
  final int _reviewsPerLoad = 2;
  bool _isLoadingMore = false;
  bool _hasMoreReviews = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      // Cek jika sudah mencapai bagian bawah
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 100) {
        _loadMoreReviews();
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _future = ApiService.fetchRestaurantDetail(widget.id);
      // Reset infinite scroll state
      _allReviews = [];
      _displayedReviews = [];
      _currentIndex = 0;
      _isLoadingMore = false;
      _hasMoreReviews = true;
    });
  }

  void _loadMoreReviews() {
    if (_isLoadingMore || !_hasMoreReviews || _allReviews.isEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulasi loading delay (bisa dihapus jika tidak perlu)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final nextIndex = _currentIndex + _reviewsPerLoad;
      final endIndex = nextIndex.clamp(0, _allReviews.length);
      
      setState(() {
        _displayedReviews = _allReviews.sublist(0, endIndex);
        _currentIndex = endIndex;
        _isLoadingMore = false;
        _hasMoreReviews = endIndex < _allReviews.length;
      });
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
          
          // Inisialisasi reviews untuk infinite scroll
          if (_allReviews.isEmpty && r.customerReviews.isNotEmpty) {
            _allReviews = _sortReviewsByDateDescending(r.customerReviews);
            _displayedReviews = _allReviews.sublist(
              0, 
              _reviewsPerLoad.clamp(0, _allReviews.length)
            );
            _currentIndex = _displayedReviews.length;
            _hasMoreReviews = _currentIndex < _allReviews.length;
          }

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
                          onShowReviews: _scrollToReviews,
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
                        // ✅ REVIEWS SECTION DENGAN INFINITE SCROLL
                        _buildReviewsSection(),
                      ],
                    ),
                  ),
                ),
                // Loading indicator untuk infinite scroll
                if (_isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                // Indicator bahwa semua data sudah dimuat
                if (!_hasMoreReviews && _allReviews.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Semua ulasan telah dimuat',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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

  Widget _buildReviewsSection() {
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_allReviews.length} ulasan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List Reviews dengan infinite scroll
          if (_displayedReviews.isEmpty)
            _buildEmptyReviews()
          else
            Column(
              children: [
                ..._displayedReviews.map((review) => _buildReviewItem(review)),
              ],
            ),
        ],
      ),
    );
  }

  // ✅ METHOD UNTUK SORTING REVIEWS BERDASARKAN TANGGAL (TERBARU PERTAMA)
  List<CustomerReview> _sortReviewsByDateDescending(
    List<CustomerReview> reviews,
  ) {
    final sorted = List<CustomerReview>.from(reviews);

    sorted.sort((a, b) {
      try {
        final dateA = _parseReviewDate(a.date);
        final dateB = _parseReviewDate(b.date);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    return sorted;
  }

  // ✅ METHOD UNTUK PARSE TANGGAL DARI STRING
  DateTime _parseReviewDate(String dateString) {
    try {
      final monthMap = {
        'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
        'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12,
        'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4, 'Mei': 5, 'Juni': 6,
        'Juli': 7, 'Agustus': 8, 'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12,
      };

      final parts = dateString.split(' ');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final monthName = parts[1];
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;
        final month = monthMap[monthName] ?? DateTime.now().month;
        return DateTime(year, month, day);
      }

      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime(1970);
    }
  }

  Widget _buildEmptyReviews() {
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
            style: TextStyle(
              fontFamily: 'Geometr415',
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Jadilah yang pertama memberikan ulasan!',
            style: TextStyle(
              fontFamily: 'Geometr415',
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showAddReviewPopup,
            child: Text(
              'Tambah Ulasan Pertama',
              style: TextStyle(fontFamily: 'Geometr415'),
            ),
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