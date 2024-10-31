library favstore;

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:smartphone_news_app/models/score.dart';

class FavstoreController {
  /// The Hive box used to store cart items.
  final Box<Article> _cartBox =
      Hive.box<Article>('cartBox');

  /// A [ValueListenable] for the cart box, allowing widgets to listen for changes in the cart.
  ValueListenable<Box<Article>> get cartListenable =>
      _cartBox.listenable();

    /// Adds a [Article] to the shopping cart.
    /// If the product is already in the cart, it updates the quantity. If not, it adds a new instance.
    void addToCart(Article item) {
        print(item);
        print(item.title);
        // Retrieve the existing item using the product ID as the key
        Article? existingItem = _cartBox.get(item.title!);
        if (existingItem == null) {
            // add a new instance
            _cartBox.put(item.title!, Article.clone(item));
        }
    }

    /// Removes a product from the shopping cart.
    /// Returns `true` if the product is successfully removed, `false` if the product is not found in the cart.
    bool removeFromCart(int productId) {
        if (_cartBox.keys.contains(productId)) {
            _cartBox.delete(productId);
            return true;
        }
        return false; // not found in the cart
    }

    /// Gets the total number of items in the shopping cart.
    int getCartItemCount() {
        return _cartBox.length;
    }

    /// Checks if a product with the given [productId] exists in the shopping cart.
    bool isItemExistsInCart(int productId) {
        return _cartBox.keys.contains(productId);
    }

    /// Removes a product from the cart using the [productId].
    /// Returns `true` if the product is successfully removed, `false` if the product is not found in the cart.
    bool removeProduct(int productId) {
        if (_cartBox.keys.contains(productId)) {
            _cartBox.delete(productId);
            return true;
        }
        return false; // not found in the cart
    }

    /// Retrieves a list of [Article] from the shopping cart.
    List<Article> getCartItems() {
        List<Article> cartItems = [];
        for (var i = 0; i < _cartBox.length; i++) {
            Article item = _cartBox.getAt(i)!;
            cartItems.add(item);
        }
        return cartItems;
    }

    /// Clears all items from the shopping cart.
    void clearCart() {
        _cartBox.clear();
    }
}

// Extension method for Iterable class
extension IterableExtensions<T> on Iterable<T> {
    T? firstWhereOrNull(bool Function(T) test) {
        for (final element in this) {
            if (test(element)) {
                return element;
            }
        }
        return null;
    }
}

/// The main class for interacting with the persistent shopping cart.
class PersistentFavstore {
    /// Initializes Hive and opens the cart box.
    Future<void> init() async {
        await Hive.initFlutter();
        // Register the adapters
        Hive.registerAdapter(ArticleAdapter());
        Hive.registerAdapter(SourceAdapter());
        //open cart box
        await Hive.openBox<Article>('cartBox');
    }

    /// Adds a [Article] to the shopping cart.
    Future<void> addToCart(Article cartItem) async {
        FavstoreController().addToCart(cartItem);
        log('CartItem added to Hive box: ${cartItem.toJson()}');
    }

    /// Removes a product from the shopping cart.
    Future<bool> removeFromCart(int productId) async {
        bool removed = FavstoreController().removeFromCart(productId);
        if (removed) {
            log('CartItem removed from Hive box: $productId');
        } else {
            log('Product not found in the cart: $productId');
        }
        return removed;
    }

    /// Gets the total number of items in the shopping cart.
    int getCartItemCount() {
        return FavstoreController().getCartItemCount();
    }

    /// Clears all items from the shopping cart.
    void clearCart() {
        FavstoreController().clearCart();
    }

    List<Article> getCartData() {
        final favstoreController = FavstoreController();
        List<Article> cartItems = favstoreController.getCartItems();
        return cartItems;
    }

    /// Displays the current cart item count using the provided widget builder.
    Widget showCartItemCountWidget(
        {required Widget Function(int itemCount) cartItemCountWidgetBuilder}) {
        return ValueListenableBuilder<Box<Article>>(
            valueListenable: FavstoreController().cartListenable,
            builder: (context, box, child) {
                var itemCount = FavstoreController().getCartItemCount();
                return cartItemCountWidgetBuilder(itemCount);
            },
        );
    }
}
