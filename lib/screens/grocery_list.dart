import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('shopping-list-app-15ab3-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in data.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      ));
    }
    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void _addItem() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));
    _loadItems();
  }

  _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: _groceryItems.length == 0
          ? Center(
              child: Text(
                'You didn\'t add items to your grocery list yet.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                    key: ValueKey(_groceryItems[index].id),
                    onDismissed: (direction) {
                      _removeItem(_groceryItems[index]);
                    },
                    child: ListTile(
                      title: Text(_groceryItems[index].name),
                      leading: Container(
                          height: 20.0,
                          width: 20.0,
                          color: _groceryItems[index].category.color),
                      trailing: Text('${_groceryItems[index].quantity}'),
                    ),
                  )),
    );
  }
}
