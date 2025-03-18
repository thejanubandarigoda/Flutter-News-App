import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool isLoading = true;
  String selectedCategory = 'general';

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
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() => isLoading = true);
    try {
      articles = await ApiService.fetchNews(category: selectedCategory);
    } catch (e) {
      print('Error fetching news: $e');
    }
    setState(() => isLoading = false);
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
      fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
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
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFA780AD).withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFA780AD).withOpacity(0.1),
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      categories[index].toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Color(0xFFE0DEF4) : Color(0xFFA780AD),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Color(0xFF9297DB),
                    backgroundColor: Color(0xFFE0DEF4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : Color(0xFFA780AD).withOpacity(0.3),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        updateCategory(categories[index]);
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) => NewsCard(article: articles[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
