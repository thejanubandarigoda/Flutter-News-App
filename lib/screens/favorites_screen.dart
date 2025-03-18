import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../screens/article_detail_screen.dart';
import '../main.dart';

class FavoritesScreen extends StatefulWidget {
  static List<Article> savedArticles = [];

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void removeArticle(int index) {
    setState(() {
      FavoritesScreen.savedArticles.removeAt(index);
    });
  }

  void clearAll() {
    setState(() {
      FavoritesScreen.savedArticles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final MainScreenState? mainScreenState = 
            context.findAncestorStateOfType<MainScreenState>();
        if (mainScreenState != null) {
          mainScreenState.onItemTapped(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              final MainScreenState? mainScreenState = 
                  context.findAncestorStateOfType<MainScreenState>();
              if (mainScreenState != null) {
                mainScreenState.onItemTapped(0);
              }
            },
          ),
          actions: [
            if (FavoritesScreen.savedArticles.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: clearAll,
              ),
          ],
        ),
        body: FavoritesScreen.savedArticles.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Color(0xFF4A6572).withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No saved articles yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4A6572),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: FavoritesScreen.savedArticles.length,
                itemBuilder: (context, index) {
                  final article = FavoritesScreen.savedArticles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: article.urlToImage.isNotEmpty
                            ? Image.network(
                                article.urlToImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Color(0xFF4A6572).withOpacity(0.1),
                                    child: Icon(
                                      Icons.newspaper,
                                      color: Color(0xFF4A6572).withOpacity(0.5),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Color(0xFF4A6572).withOpacity(0.1),
                                child: Icon(
                                  Icons.newspaper,
                                  color: Color(0xFF4A6572).withOpacity(0.5),
                                ),
                              ),
                      ),
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232F34),
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        article.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF4A6572),
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Color(0xFFF9AA33),
                        onPressed: () => removeArticle(index),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
