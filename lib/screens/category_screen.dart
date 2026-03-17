import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryScreen({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = ['general', 'business', 'technology', 'health', 'sports', 'entertainment'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(
              category.toUpperCase(),
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              onCategorySelected(category);
              Navigator.pop(context); // Close the category screen
            },
          );
        },
      ),
    );
  }
}
