import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:meal_app/data/dummy_data.dart';
// import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
// import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/providers/favorites_provider.dart';
import 'package:meal_app/providers/filters_provider.dart';

const kInitalFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

/* ? ConsumerStatefulWidget
- is StatefulWidget provided by Riverpod package koji daje neku f-nost koja nam omogucava da osluskujemo nase provajdere i promene nastale u njihovim . da smo imali StatelessWidget, koristili bismo ConsumerWidget.
Naravno, i ovde sad umesto State koristimo ConsumerState, i dole isto u _TabsScreenState extends ConsumerState */
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

// class _TabsScreenState extends State<TabsScreen> {
class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          // inace da se ne bi resetovali filteri kada idemo nazad na FiltrersScreen, moramo proslediti currentFilters u FiltersScreen
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    /* ovde zelimo da reachujemo FavoriteMeals provider da dohvatimo ovaj _favoriteMeals da bismo ih prosledili u MealsScreen.
    Ovo smo takodje mogli uraditi unutar MealsScreen umesto ovde, jer na kraju krajeva tamo zelimo ove favoriteMeals, medjutim, imaj na umu da se MealsScreen ne koristi samo u FavoritesScreen vec i unutar CategoriesScreen onda kada selektujemo kategoriju, i tada ne zelimo da pokazemo samo favorites, vec sve meals u toj kategoriji. Zato ima logike da MealsScreen ostavimo configurable i prihvatimo meals koja bi trebalo ovde biti kao parametar kako bi MealsScreen moglo biti ponovo koriscen unutar razlicitih Screenova. I mi zato dobijamo favoriteMeals na mestu gde mi zapravo i trebamo favoriteMeals, a to bi bilo ovde kada je ovaj tab selektovan u nasem TabsScreen-u */
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
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
