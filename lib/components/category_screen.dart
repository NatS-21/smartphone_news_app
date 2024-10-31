import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smartphone_news_app/bloc/category_event.dart';
import 'package:smartphone_news_app/bloc/category_state.dart';
import 'package:smartphone_news_app/bloc/category_bloc.dart';
import 'package:smartphone_news_app/components/favstore.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String categoryName = 'iphone';
  File? _userImage;

  // Перечень категорий для бокового меню
  List<String> categoriesList = [
    'iphone',
    'samsung galaxy',
    'google pixel',
    'xiaomi',
    'oneplus',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserImage();
    context.read<NewsCatsBloc>().add(NewsCategories('iphone'));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/user_image.png');

      setState(() {
        _userImage = savedImage;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userImagePath', savedImage.path);
    }
  }

  Future<void> _loadUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImagePath');

    if (imagePath != null) {
      setState(() {
        _userImage = File(imagePath);
      });
    }
  }

  @override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppBar(
      title: const Text('News Categories'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: _userImage != null
              ? CircleAvatar(backgroundImage: FileImage(_userImage!))
              : const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.upload, color: Colors.blue, size: 20),
                ),
          onPressed: _pickImage,
        ),
        PersistentFavstore().showCartItemCountWidget(
          cartItemCountWidgetBuilder: (itemCount) => IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            icon: Badge(
              label: Text(itemCount.toString()),
              child: const Icon(Icons.favorite_border),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ),
            );
          },
        ),
      ],
    ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Выберите категорию',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            for (var category in categoriesList)
              ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    categoryName = category;
                  });
                  Navigator.pop(context);
                  context.read<NewsCatsBloc>().add(NewsCategories(category));
                },
              ),
          ],
        ),
      ),
      body: BlocBuilder<NewsCatsBloc, NewsCatsState>(
        builder: (context, state) {
          if (state.categoriesStatus == Status.initial) {
            return const Center(
              child: SpinKitCircle(size: 50, color: Colors.blue),
            );
          } else if (state.categoriesStatus == Status.failure) {
            return Center(
              child: Text(state.categoriesMessage.toString()),
            );
          } else if (state.categoriesStatus == Status.success) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.newsCategoriesList!.articles!.length,
                itemBuilder: (context, index) {
                  final article = state.newsCategoriesList!.articles![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child:
                                    SpinKitCircle(size: 30, color: Colors.blue),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error_outline,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title ?? 'No title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                article.description ??
                                    'No description available',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    article.source!.name ??
                                        'No source available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      PersistentFavstore().addToCart(article);
                                    },
                                    icon: Icon(Icons.favorite),
                                  ),
                                ],
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
