import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../widgets/news_card.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool isLoading = true;
  late String selectedCategory;

  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    // Use the persisted default category on startup
    selectedCategory = SettingsService.categoryNotifier.value;
    fetchNews();

    // If the saved country changes (via Settings), reload news
    SettingsService.countryNotifier.addListener(_onCountryChanged);
    // If the default category changes via Settings, update selection + reload
    SettingsService.categoryNotifier.addListener(_onCategoryChanged);
  }

  @override
  void dispose() {
    SettingsService.countryNotifier.removeListener(_onCountryChanged);
    SettingsService.categoryNotifier.removeListener(_onCategoryChanged);
    super.dispose();
  }

  void _onCountryChanged() {
    fetchNews();
  }

  void _onCategoryChanged() {
    setState(() => selectedCategory = SettingsService.categoryNotifier.value);
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() => isLoading = true);
    try {
      articles = await ApiService.fetchNews(category: selectedCategory);
    } catch (e) {
      debugPrint('Error fetching news: $e');
    }
    setState(() => isLoading = false);
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(
                  onCategorySelected: updateCategory,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA780AD).withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFA780AD).withValues(alpha: 0.1),
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      categories[index].toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFE0DEF4)
                            : const Color(0xFFA780AD),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF9297DB),
                    backgroundColor: const Color(0xFFE0DEF4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFFA780AD).withValues(alpha: 0.3),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) updateCategory(categories[index]);
                    },
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : articles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.newspaper,
                                size: 64,
                                color:
                                    const Color(0xFF4A6572).withValues(alpha: 0.4)),
                            const SizedBox(height: 16),
                            const Text('No articles found',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF4A6572))),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) =>
                            NewsCard(article: articles[index]),
                      ),
          ),
        ],
      ),
    );
  }
}
