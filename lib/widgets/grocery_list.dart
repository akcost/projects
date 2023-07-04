import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:shopping/models/grocery_item.dart';
import 'package:shopping/widgets/new_item.dart';
import 'package:shopping/providers/groceries_provider.dart';

class GroceryList extends ConsumerStatefulWidget {
  const GroceryList({super.key});

  @override
  ConsumerState<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryList> {
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      await ref.read(groceriesProvider.notifier).getAllGroceryItems();
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
        _error = "Something went wrong! Please try again later.";
      });
    }
  }

  void _addItem() async {
    Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
  }

  void _removeItem(GroceryItem groceryItem, int index) async {
    try {
      await ref.read(groceriesProvider.notifier).removeGroceryItem(groceryItem.id);
    } on Exception catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GroceryList()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oops something went wrong, please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groceries = ref.watch(groceriesProvider);

    Widget content = const Center(
      child: Text("No items added yet."),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (groceries.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceries.length,
        itemBuilder: (ctx, index) => Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            _removeItem(groceries[index], index);
            groceries.removeAt(index);
          },
          key: ValueKey(groceries[index].id),
          child: ListTile(
            title: Text(groceries[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceries[index].category.color,
            ),
            trailing: Text(groceries[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
