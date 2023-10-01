import 'package:flutter/material.dart';

import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/meals.dart';

// sad pvde koristimo StatefulWidget jer cemo ovde menjati neki state u zavisnosti koji je tab kliknut cemo prikazivati neki view
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = const MealsScreen(meals: []);
      activePageTitle = 'Your Favorites';
    }

    // appBar title i body sadrzaj ce biti dinamicki u zavisnosti koji je tab aktivan, ofc
    return Scaffold(
      /*  ali sad postoji problem, imamo prikazano vise appBar title-ova, jer screens koje koristimo, svaki od njih ima appBAr title. Za categories.dart je lako, samo cemo tamo ukloniti Scaffold sa appBar i body (ostavljamo body content tho) 
      Za meals.dart je teze jer ne mozemo samo da ukonimo Scaffold jer se ono koristi i u categories.dart, a tamo nam je potreban Scaffold jer tamo nemamo bottom. ZAto cemo KONDICIONALNO koristiti taj Scaffold, i stavicemo da je title u meals.dart optiona sa String? */
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      //? bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        /* 
        index tab-a koji ce biti tapnut, items je lista tabova.
        BottomNavigationBarItem je flutter built-in klasa.
        Kada god selektujemo/tapnemo neki od tabovam truggerujemo _selectPage f-ju i apdejtujemo _selectedPageIndex
        
        ? currentIndex: _selectedPageIndex highlightuje tapnut tab */
        // onTap: (index) {},
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
