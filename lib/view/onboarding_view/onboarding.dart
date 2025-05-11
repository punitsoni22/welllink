import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:welllink/utils/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final CarouselSliderControllerImpl _carouselController =
  CarouselSliderControllerImpl();

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Welcome to Our App',
      'description':
      'Discover amazing features and enjoy your journey with us.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Get Started',
      'description': 'Join thousands of users and experience something great.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPage < onboardingData.length - 1) {
            // Move to next page if not on the last page
            _carouselController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            // Navigate to login view if on the last page
            Get.offNamed(AppRoutes.loginView);
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: onboardingData.length,
              itemBuilder: (context, index, realIndex) {
                return OnboardingPage(
                  imageUrl: onboardingData[index]['image']!,
                  title: onboardingData[index]['title']!,
                  description: onboardingData[index]['description']!,
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.8,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 1,
                enableInfiniteScroll: false,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => buildDot(index, context),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image takes all available space minus text area
        Expanded(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          description,
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
