import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';

import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';

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
  // pogledaj @favorites text u meal_details.dart
  final List<Meal> _favoriteMeals = [];

// fav item feedback, pravimo toast notif tj snackbar
  void _showInfoMessage(String message) {
    // prvo cistimo sve snackbar ukoliko je neki ostao
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    /* ! medjutim, kada add ili remove fav item iz favorites, lista se ne apdejtuje, osim ako ne navigujemo na Categories pa ponovo u Favorites. To je jer ne koristimo setState() ovde da svaki x apdejtujemo state u zavisnosti da li smo dodali ili uklonili item iz favorites.
    Samo nzm, on je negde stavio _showInfoMessage u setState a u else je stavio van setState, wtf */
    if (isExisting) {
      // _favoriteMeals.remove(meal);
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      // _favoriteMeals.add(meal);
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite.');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      // Navigator.of(context).pop();

      /* ? pushReplacement 
      * Mozda recimo ne zelimo da kada idemo back da se vratimo jedan unazad korak tj da koristimo Stack of Screens, tj gomilanje/slojeviti screenova, vcec zelimo da trenutno aktivni screen (u ovom slucaju TabsScreen) ZAMENIMO sa sledecim skrinom (u ovom slucaju sa FiltersScreen), i da nas back button onda nece raditi kao inace i nece nas vratiti unazad, jer nema cemu da se vrati. I ugl tada izlazimo iz app. To radimo sa pushReplacement */
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (ctx) => const FiltersScreen(),
      // ));
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const FiltersScreen(),
      ));
    }
    //  else {
    //   /* za else je 'meals' a tada loadujemo TabsScreen. Al ono sto je bitno ovde za else, jeste da imamo na umu da mi vec jesmo na TabsScreen-u.
    //   Ako otvorimo drawer iz TabsScreen-a i selektujemo Meals u tom Draweru, mi zapravo samo zelimo da zatvorimo Drawer, dakle ne loadujemo nikakav novi skrin, jer smo vec tu gde treba da budemo */
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage =
        CategoriesScreen(onToggleFavorite: _toggleMealFavoriteStatus);
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    // appBar title i body sadrzaj ce biti dinamicki u zavisnosti koji je tab aktivan, ofc
    return Scaffold(
      /*  ali sad postoji problem, imamo prikazano vise appBar title-ova, jer screens koje koristimo, svaki od njih ima appBAr title. Za categories.dart je lako, samo cemo tamo ukloniti Scaffold sa appBar i body (ostavljamo body content tho) 
      Za meals.dart je teze jer ne mozemo samo da ukonimo Scaffold jer se ono koristi i u categories.dart, a tamo nam je potreban Scaffold jer tamo nemamo bottom. ZAto cemo KONDICIONALNO koristiti taj Scaffold, i stavicemo da je title u meals.dart optiona sa String? */
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      /* ? Drawer
      side drawer dodajemo u Scaffold jer ce se i on kreirati za svaki skrin posebno. Flutter ima svoju optimizovanu Drawer klasu, ali mi zelimo da kreiramo nas custom drawer widget jer zelimo da dodamo dosta contenta u drawer! */
      drawer: MainDrawer(onSelectScreen: _setScreen),
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
