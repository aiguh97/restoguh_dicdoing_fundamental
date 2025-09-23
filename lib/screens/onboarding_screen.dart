import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/style/colors/restoguh_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _controller = PageController();

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/svg/tracking.svg",
      "title": "Nearby restaurants",
      "subtitle":
          "You don't have to go far to find good restaurant, we have provided all the restaurants that is near you.",
    },
    {
      "image": "assets/svg/order.svg",
      "title": "Select the Favorites Menu",
      "subtitle":
          "Now eat, don't leave the house. You can choose your favorite food only with one click.",
    },
    {
      "image": "assets/svg/food.svg",
      "title": "Good food at a cheap price",
      "subtitle": "You can eat at expensive restaurants with affordable price.",
    },
  ];

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);
    Navigator.pushReplacementNamed(context, "/home");
  }

  Widget _buildSvgImage(String assetPath, {double width = 280}) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      placeholderBuilder: (BuildContext context) => Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(20),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            RestoguhColors.blue.primaryColor,
          ),
        ),
      ),
      semanticsLabel: 'Onboarding Image',
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingProvider>(
      create: (_) => OnboardingProvider(),
      child: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: provider.setPage,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildSvgImage(page["image"]!),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                page["title"]!,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.black87,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page["subtitle"]!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: provider.currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: provider.currentPage == index
                                    ? RestoguhColors.blue.primaryColor
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => _completeOnboarding(context),
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (provider.currentPage == _pages.length - 1) {
                                  _completeOnboarding(context);
                                } else {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    RestoguhColors.blue.primaryColor,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: Icon(
                                provider.currentPage == _pages.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
