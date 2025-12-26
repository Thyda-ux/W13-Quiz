import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int _currentIndex = 0;

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));
    if (dummyGroceryItems.isNotEmpty) {
      content = IndexedStack(
        index: _currentIndex,
        children: [
          const GroceryTab(),
          SearchTab(groceries: dummyGroceryItems),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.lightBlue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: "Groceries",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({super.key, required this.groceries});

  final List<Grocery> groceries;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String filteredString = "";

  List<Grocery> get filteredGroceries {
    if (filteredString.isEmpty) {
      return widget.groceries;
    } else {
      return widget.groceries
          .where((grocery) =>
              grocery.name.toLowerCase().contains(filteredString.toLowerCase()))
          .toList();
    }
  }

  void onSearch(String value) {
    setState(() {
      filteredString = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          hintText: "Search",
          leading: const Icon(Icons.search),
          onChanged: onSearch,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredGroceries.length,
            itemBuilder: (context, index) {
              return GroceryTile(grocery: filteredGroceries[index]);
            },
          ),
        ),
      ],
    );
  }
}

class GroceryTab extends StatelessWidget {
  const GroceryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyGroceryItems.length,
      itemBuilder: (context, index) {
        final grocery = dummyGroceryItems[index];
        return GroceryTile(grocery: grocery);
      },
    );
  }
}
