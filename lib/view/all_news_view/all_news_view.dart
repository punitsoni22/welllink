import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../home_view/controller/home_controller.dart';
import '../home_view/model/news_model.dart';
import '../home_view/widget/news_tile.dart';

class AllNewsScreen extends StatefulWidget {
  final List<NewsItem> newsItems;

  const AllNewsScreen({super.key, required this.newsItems});

  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  List<NewsItem> _filteredNews = [];

  @override
  void initState() {
    super.initState();
    _filteredNews = widget.newsItems;
  }

  void _filterNews(String query) {
    setState(() {
      _filteredNews = controller.newsItems
          .where((news) =>
              news.title.toLowerCase().contains(query.toLowerCase()) ||
              news.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _loadMoreNews() {
    controller.fetchNews(
        page: controller.currentPage.value + 1, isLoadMore: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.newspaper,
              color: Colors.blue.shade600,
              size: 24.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              'Health News',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications_outlined, color: Colors.grey.shade700),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterNews,
              decoration: InputDecoration(
                hintText: 'Search health news...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                ),
              ),
            ),
          ),
          // News List
          Expanded(
            child: Obx(() {
              final newsToShow = _searchController.text.isEmpty
                  ? controller.newsItems
                  : _filteredNews;

              if (controller.isLoading.value && controller.newsItems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (newsToShow.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/demo.png',
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'No news found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try searching with different keywords',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.currentPage.value = 1;
                  controller.hasMoreNews.value = true;
                  await controller.fetchNews();
                  setState(() {
                    _filteredNews = controller.newsItems;
                  });
                },
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                  itemCount: newsToShow.length +
                      (controller.hasMoreNews.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == newsToShow.length &&
                        controller.hasMoreNews.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _loadMoreNews,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Load More',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }
                    return NewsTile(news: newsToShow[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
