import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'favstore.dart';
import '../models/score.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final List<Article> favoriteArticles = PersistentFavstore().getCartData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: favoriteArticles.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = favoriteArticles[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.description ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              article.source!.name ?? '', 
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(DateTime.now()),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Нет избранных статей'),
            ),
    );
  }
}
