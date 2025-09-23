import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/detail_screen.dart';
import '../../providers/home_provider.dart';
import '../../static/restoguh_list_result_state.dart';
import '../../widgets/restaurant_card.dart';
import '../../style/typography/typography_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeProvider>().fetchRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context, HomeProvider homeProvider) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: homeProvider.isSearching ? 72 : 54,
      title: homeProvider.isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                border: InputBorder.none,
                hintStyle: RestoguhTextStyles.bodyLargeRegular.copyWith(
                  color: Colors.white,
                ),
              ),
              style: RestoguhTextStyles.bodyLargeRegular.copyWith(
                color: Colors.white,
              ),
              textInputAction: TextInputAction.search,
              onChanged: homeProvider.searchRestaurantsRealtime,
            )
          : Text('Restoguh', style: RestoguhTextStyles.displayLarge),
      actions: [
        IconButton(
          icon: Icon(homeProvider.isSearching ? Icons.close : Icons.search),
          onPressed: () {
            if (homeProvider.isSearching) {
              _searchController.clear();
              homeProvider.stopSearch();
            } else {
              homeProvider.startSearch();
              Future.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).requestFocus(FocusNode());
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: _buildAppBar(context, homeProvider),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Center(
            child: switch (provider.state) {
              RestoguhListLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
              RestoguhListLoadedState(data: var restaurants, query: var q) =>
                restaurants.isEmpty
                    ? Center(
                        child: Text(
                          q.isEmpty
                              ? "Tidak ada restoran"
                              : "Hasil pencarian \"$q\" tidak ditemukan",
                        ),
                      )
                    : ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailScreen(id: restaurant.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
              RestoguhListErrorState(error: var message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/no_internet.png", width: 250),
                    const SizedBox(height: 16),
                    const Text(
                      'Koneksi Terputus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // panggil ulang fetchRestaurants
                        context.read<HomeProvider>().fetchRestaurants();
                      },
                      child: const Text('Refresh'),
                    ),
                    const SizedBox(height: 16),
                    // Jika kamu masih ingin menampilkan detail error (opsional)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _ => const SizedBox(),
            },
          );
        },
      ),
    );
  }
}
