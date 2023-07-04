import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/models/grocery_item.dart';
import 'package:shopping/models/category.dart';
import 'package:http/http.dart' as http;

import 'package:shopping/data/categories.dart';
import 'package:shopping/config.dart';

class GroceriesNotifier extends StateNotifier<List<GroceryItem>> {
  GroceriesNotifier() : super([]);

  Future<void> saveGroceryItem(
      String name, int quantity, Category category) async {
    try {
      final url = Uri.https(
          databaseUrl,
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'quantity': quantity,
            'category': category.title,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      final Map<String, dynamic> resData = jsonDecode(response.body);

      state = [
        ...state,
        GroceryItem(
          id: resData['name'],
          name: name,
          quantity: quantity,
          category: category,
        )
      ];
    } on Exception catch (e) {
      throw (Exception(e));
    }
  }

  Future<void> removeGroceryItem(String groceryItemId) async {
    final url = Uri.https(
        databaseUrl,
        'shopping-list/$groceryItemId.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw Exception("Failed to fetch data please try again later.");
    }

    state = state.where((item) => item.id != groceryItemId).toList();
  }

  Future<void> getAllGroceryItems() async {
    final url = Uri.https(
        databaseUrl,
        'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      if (response.body == "null") {
        return;
      }

      final Map<String, dynamic> listData = jsonDecode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      state = loadedItems;
    } catch (err) {
      throw Exception(err);
    }
  }
}

final groceriesProvider =
    StateNotifierProvider<GroceriesNotifier, List<GroceryItem>>((ref) {
  return GroceriesNotifier();
});
