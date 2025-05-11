import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class HomeController extends GetxController {
  // Authentication-related variables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;

  // News-related variables
  RxList<NewsItem> newsItems = <NewsItem>[].obs;
  RxString newsErrorMessage = ''.obs;

  RxInt currentPage = 1.obs;
  RxBool hasMoreNews = true.obs;
  RxInt selectedNavIndex = 1.obs;

  // Firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // Check authentication status
    fetchNews(); // Fetch news data
  }

  // Check if user is logged in and update related variables
  void checkLoginStatus() async {
    try {
      isLoading.value = true;
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        isLoggedIn.value = true;
        userName.value = user.displayName ?? 'Dr. Jane Doe'; // Fallback name
        userEmail.value = user.email ?? '';
      } else {
        isLoggedIn.value = false;
        userName.value = 'Dr. Jane Doe'; // Default name if not logged in
        userEmail.value = '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check login status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch news from NewsAPI
  Future<void> fetchNews({int page = 1, bool isLoadMore = false}) async {
    const apiKey = '8e73c2a2af1f4eb5bfc170ca56e445f8';
    const pageSize = 10; // Number of articles per page
    final url =
        'https://newsapi.org/v2/everything?q=healthcare&sortBy=publishedAt&pageSize=$pageSize&page=$page&apiKey=$apiKey';

    try {
      isLoading.value = !isLoadMore;
      newsErrorMessage.value = '';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>;

        final newItems = articles.map((article) {
          return NewsItem(
            title: article['title'] ?? 'No Title',
            description: article['description'] ?? 'No Description',
            date: article['publishedAt']?.substring(0, 10) ?? 'No Date',
            imageUrl: article['urlToImage'] ?? 'assets/images/demo.png',
            url: article['url'] ?? '',
          );
        }).toList();

        if (isLoadMore) {
          newsItems.addAll(newItems);
        } else {
          newsItems.assignAll(newItems);
        }

        // Check if there are more articles
        hasMoreNews.value = articles.length == pageSize;
        if (hasMoreNews.value) {
          currentPage.value = page;
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      newsErrorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Function to handle navigation
  void changeNavIndex(int index) {
    selectedNavIndex.value = index;

    // Add navigation logic here if needed
    switch (index) {
      case 0:
        // Home page (current page)
        break;
      case 1:
        // Navigate to Appointments
        // Get.to(() => AppointmentsScreen());
        break;
      case 2:
        // Navigate to Profile
        // Get.to(() => ProfileScreen());
        break;
    }
  }
}
