import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:meal_app/data/dummy_data.dart';
// import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/providers/favorites_provider.dart';
import 'package:meal_app/providers/filters_provider.dart';

const kInitalFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// sad pvde koristimo StatefulWidget jer cemo ovde menjati neki state u zavisnosti koji je tab kliknut cemo prikazivati neki view
// class TabsScreen extends StatefulWidget {
/* class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
} */

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
  // pogledaj @favorites text u meal_details.dart
  // final List<Meal> _favoriteMeals = [];

// ovo je inicijalna vrednost koja bi treba da bude apdejtovana sa podacima iz FiltersScreen-a
  // Map<Filter, bool> _selectedFilters = kInitalFilters; //@ brisemo currentFilters: _selectedFilters jer dodajemo filters_provider.dart

/* @SA favorites_provider mozemo da premesteno u meals_details.dart u IconButton onPressed
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
*/

/* @MOZEMO UKLONITI KAD KORISTIMO RIVERPOD TJ FAVORITE_PROVIDER
// i to cemo da koristimo u StateNotifierProvider
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
*/

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
      // @ takodje nam ne treba final result jer vise ne treba da dohvatamo ove podatke od kad dodajemo filters_provider.dart jer se sve tamo dogadja
      // final result = await Navigator.of(context).push<Map<Filter, bool>>(
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          // inace da se ne bi resetovali filteri kada idemo nazad na FiltrersScreen, moramo proslediti currentFilters u FiltersScreen
          //@ brisemo currentFilters: _selectedFilters jer dodajemo filters_provider.dart
          // builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
          builder: (ctx) => const FiltersScreen(),
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
      //@ brisemo jer dodajemo filters_provider.dart
      // setState(() {
      //   _selectedFilters = result ?? kInitalFilters;
      // });
    }
    //  else {
    //   /* za else je 'meals' a tada loadujemo TabsScreen. Al ono sto je bitno ovde za else, jeste da imamo na umu da mi vec jesmo na TabsScreen-u.
    //   Ako otvorimo drawer iz TabsScreen-a i selektujemo Meals u tom Draweru, mi zapravo samo zelimo da zatvorimo Drawer, dakle ne loadujemo nikakav novi skrin, jer smo vec tu gde treba da budemo */
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
/*
   //@ BEZ FLUTTER PROVIDER 
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
*/

    /* @ SA FLUTTER PROVIDER 
    Posto extendujemo ConsumerState, dobijamo pristup ref propertiju, koji biva pandan widget propertiju.
    ! ref properti nam omogucava da set-upujemo listenere nasim provajderima.
    ! imamo vise ref. metoda, ali najvazniji su ref.read() da dohvatimo podatke iz nasem provajdera, ref.watch() da setapujemo listener koji ce se postarati da se build method izvrsava svaki x kada se neka promena na nasim podacima desi.
    Preporuka riverpod docsa je da se sto vise koristi watch (i to odmah na pocetku) iako mzd tehnicki samo jednom treba da read-ujemo podatke, jer na ovaj nacin, ako ikada promenimo nasu logiku, izbecicemo neke bagove koje bismo recimo zaboravili da zamenimo read sa watch.
    watch needs a parametar koji je predstavlja providera.
    Dakle, ovaj build ce se okinuti kada god se neki pdoatak u mealsProvider promeni. Watch takodje vraca podatke od provajdera kog watchujemo
    
    ? ProviderScope
    ! kada koristimo Flutter Riverpod, moramo da idemo u main.dart i u void main() { runApp(const App()) } wrapujemo ovo const App() u ProviderScope() widget i time unlockujemo ovaj behind the scenes state management f-naliti, a wrapujemo citav App() da bi svi wigeti u citavoj app mogli koristiti ove Riverpod feature. Dakle ako znamo da bi samo odredjen deo app koristio te feature, onda mozemo samo taj deo da wrapujemo u PRoviderScope */
    final meals = ref.watch(mealsProvider);

    final activeFilters = ref.watch(filtersProvider);

    final availableMeals = meals.where((meal) {
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      /* @ menjamo  jer dodajemo filters_provider.dart   
    final availableMeals = meals.where((meal) {
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
      */

      // bez ovoga ovde samo imamo gomilu cekera koji potencijalno vracaju false, ali nikad ne vracamo true za jela koja ustvari zelimo da zadrzimo
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus, //@ ukalnjamo jer kor. favorites_provider.dart
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    /* ovde zelimo da reachujemo FavoriteMeals provider da dohvatimo ovaj _favoriteMeals da bismo ih prosledili u MealsScreen.
    Ovo smo takodje mogli uraditi unutar MealsScreen umesto ovde, jer na kraju krajeva tamo zelimo ove favoriteMeals, medjutim, imaj na umu da se MealsScreen ne koristi samo u FavoritesScreen vec i unutar CategoriesScreen onda kada selektujemo kategoriju, i tada ne zelimo da pokazemo samo favorites, vec sve meals u toj kategoriji. Zato ima logike da MealsScreen ostavimo configurable i prihvatimo meals koja bi trebalo ovde biti kao parametar kako bi MealsScreen moglo biti ponovo koriscen unutar razlicitih Screenova. I mi zato dobijamo favoriteMeals na mestu gde mi zapravo i trebamo favoriteMeals, a to bi bilo ovde kada je ovaj tab selektovan u nasem TabsScreen-u */
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        // meals: _favoriteMeals, //@ ukalnjamo jer kor. favorites_provider.dart
        meals: favoriteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus, //@ ukalnjamo jer kor. favorites_provider.dart
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
