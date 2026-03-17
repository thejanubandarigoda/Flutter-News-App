import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../screens/article_detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../services/settings_service.dart';

class NewsCard extends StatefulWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    SettingsService.fontSizeNotifier.addListener(_onFontChanged);
  }

  @override
  void dispose() {
    SettingsService.fontSizeNotifier.removeListener(_onFontChanged);
    super.dispose();
  }

  void _onFontChanged() => setState(() {});

  void toggleFavorite() {
    setState(() {
      isSaved = !isSaved;
      if (isSaved) {
        FavoritesScreen.savedArticles.add(widget.article);
      } else {
        FavoritesScreen.savedArticles.remove(widget.article);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: widget.article)),
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF344955).withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.article.urlToImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.article.urlToImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A6572).withValues(alpha: 0.1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.newspaper,
                                    size: 50,
                                    color: const Color(0xFF4A6572).withValues(alpha: 0.5),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'News',
                                    style: TextStyle(
                                      color: Color(0xFF4A6572),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0xFF232F34).withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              widget.article.source.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6572).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.newspaper,
                          size: 50,
                          color: const Color(0xFF4A6572).withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'News',
                          style: TextStyle(
                            color: Color(0xFF4A6572),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.title,
                      style: TextStyle(
                        fontSize: SettingsService.fontSizeNotifier.value + 4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF232F34),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.article.description,
                      style: TextStyle(
                        fontSize: SettingsService.fontSizeNotifier.value,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFB0BEC5)
                            : const Color(0xFF4A6572),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.article.author,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFF9AA33),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Color(0xFFF9AA33) : Color(0xFF4A6572),
                          ),
                          onPressed: toggleFavorite,
                        ),
                      ],
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
}
