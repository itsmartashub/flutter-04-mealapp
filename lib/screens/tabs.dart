import 'package:flutter/material.dart';

import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';

const kInitalFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

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

// ovo je inicijalna vrednost koja bi treba da bude apdejtovana sa podacima iz FiltersScreen-a
  Map<Filter, bool> _selectedFilters = kInitalFilters;

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      // Navigator.of(context).pop();

      /* ? pushReplacement 
      * Mozda recimo ne zelimo da kada idemo back da se vratimo jedan unazad korak tj da koristimo Stack of Screens, tj gomilanje/slojeviti screenova, vcec zelimo da trenutno aktivni screen (u ovom slucaju TabsScreen) ZAMENIMO sa sledecim skrinom (u ovom slucaju sa FiltersScreen), i da nas back button onda nece raditi kao inace i nece nas vratiti unazad, jer nema cemu da se vrati. I ugl tada izlazimo iz app. To radimo sa pushReplacement */
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (ctx) => const FiltersScreen(),
      // ));

      /* ? get Future
      Zasto ovo ovde push sada vraca Future (vidi __Future u filters.dart). Zasto smo napravili da dobijamo Future a ne direkt Map, jer kada pushujemo ovaj screen u stack of screens ne dobijamo odmah te podatke, zapravov korisnik moze da interaguje sa tim skrinom i on moce mzd ici nazad (stisnuti back) nakon 10s, 10min, ili 10 hours, mi to ne znamo. I zato se zove Future, ne vracamo dostupne vrednosti odmah vec negde u nekom buducem trenutku kada korisnik odluci da naviguje nazad.
      Da bismo koristili ovde Future, u ovoj _setScreen fn dodajemo async da bismo ovde mogli da kor await i sacuvamo u result varijabli> ali to ce da se desi kada korisnik ode unazad, moramo dakle da cekamo na to tj await-ujemo da se to desi. 
      Takodje, ispred .push cemo dodati angular brackets <> i tu definisati koje podatke ocekujemo da se vrate by push. Kao i za sve genericke tipove kor <>. Map je sam po sebi genericki tip pa i njemu stavljamo <> gde stavljamo Filter enum da bude key, a value da bude bool jer imamo booleans */
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          // inace da se ne bi resetovali filteri kada idemo nazad na FiltrersScreen, moramo proslediti currentFilters u FiltersScreen
          builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
        ),
      );
      // print(result); // output: {Filter.glutenFree: true, Filter.lactoseFree: false, Filter.vegetarian: true, Filter.vegan: false}

      /* Ovakvo cuvanje vrednosti nije dovoljno, jer ako takodje zelimo da se postaramo da je build metod izvrsen opet tako da bi apdejtovani filteri il iapdejtovana lista dostupnih meals, bili prosledjeni u CategoriesScreen. Btw, ne u MealsScreen jer ne zelimo da filtriramo meals koji su vidljivi na tom skrinu.
      Favorites ce uvek biti vidljivi bez obz koji filter je selektovan.
      
      ``` ?? cekira da li je vrednost ispred njega (??) null, i ako jeste, koristice se fallback vrednost navedena posle ??
      Dakle ako results bude null, koristicemo kInitalFilters za value selektovanog filtera.
      
      Ovde setujemo _selectedFilter kada god dodjemo sa FiltersScreen-a, isada ove _selectedFilter mozemo da koristimo da bismo apdejtovali meals koje cemo prikazati onda kada izaberemo kategoriju na CategoriesScreen. Pa sada kada prosledjujemo filter podatke u CategoriesScreen imamo dve glavne opcije:
      1. Mozemo ili da prosledimo listu dostupnih jela koji potom mogu biti izabrani i korisceni unutar CategoriesScreen-a, ili 
      2. Da prosledimo filters i dodamo logiku za filtriranje jela u ovaj CategoriesScreen */
      setState(() {
        _selectedFilters = result ?? kInitalFilters;
      });
    }
    //  else {
    //   /* za else je 'meals' a tada loadujemo TabsScreen. Al ono sto je bitno ovde za else, jeste da imamo na umu da mi vec jesmo na TabsScreen-u.
    //   Ako otvorimo drawer iz TabsScreen-a i selektujemo Meals u tom Draweru, mi zapravo samo zelimo da zatvorimo Drawer, dakle ne loadujemo nikakav novi skrin, jer smo vec tu gde treba da budemo */
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // ovim uzvicnikom isped _selectedFilter[Filter.glutenFree]! govorimo da _selectedItems nikad nece biti null, a nece jer samo jer smo gore uvek setovali da bar inicijalno bude onaj pocetni Map, tj kInitialFilters
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      // bez ovoga ovde samo imamo gomilu cekera koji potencijalno vracaju false, ali nikad ne vracamo true za jela koja ustvari zelimo da zadrzimo
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
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
