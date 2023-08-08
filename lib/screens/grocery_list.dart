import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
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
