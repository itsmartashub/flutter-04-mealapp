import 'package:flutter/material.dart';

import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/models/category.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/widgets/category_grid_item.dart';
import 'package:meal_app/screens/meals.dart';

/* ? Explicit Animations 
Sada planiramo da dodamo Explicitnu animaciju da kada ucitamo MEals screen tj kategorije, da svaki category item se slide-inuje od dole.
Da bismo to uradili moramo prvo da StatelessWidget promenimo u StatefulWidget: idemo right click > refactor > convert to StatefulWidget jer kada dodajemo explicit animaciju u widget, moramo ga dodati u State object tog widgeta. Jer behind-the-scene, aniamcija setuje State i apdejtuje UI za sve vreme koliko traje animacija, a za re-exectovanje build metoda je potreban StatefulWidget */
class CategoriesScreen extends StatefulWidget {
  // moramo u tabs.dart gde kor ovu klasu i dodajemo ovaj property onToggleFavorite
  const CategoriesScreen({
    super.key,
    // required this.onToggleFavorite, //@ ukalnjamo jer kor. favorites_provider.dart
    required this.availableMeals,
  });

  // final void Function(Meal meal) onToggleFavorite; //@ ukalnjamo jer kor. favorites_provider.dart
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

/* ? with
Da bismo kor AnimationController i njegov vsync dole, tj da bi on imao informaciju o frame-rate, potrebno je da dodamo with keywork gore posle class _CategoriesScreenState extends State<CategoriesScreen>, koji inace necemo koristiti cesto, ali je neophodan za explicitne animacije. Ovaj keyword je neophodan da bismo klasi dodali Mixin, sto mu dodje nova klasa merdzovana u ovu klasu nudeci raznorazne feature. A klasa koja bi ovde trebalo biti mrdzovana je:
? SingleTickerProviderStateMixin 
Ovu klasu kor ako imamo jednu animaciju, a ako bismo imali vise animacija, onda bismo mrdzovali klasu:
? TickerProviderStateMixin  */
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  /* ovde cemo da cuvamo value of type animationController.
  Ovo late kazuje da je ovo varijabla koja ce imati vrednost sto je pre moguce, kada prvi x bude koristena, a ne kad je klasa kreirana.
  Kako god, i dalje treba da navedemo tip promenljive, sto je u ovom slucaju AnimationController sto je built-in flutter type */
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    /* ? vsync
    - vsync moramo setovati i ono zeli nesto sto se zove TickerProvider; vsync omogucava da se ova animacija izvrsi za svaki frejm, recimo 60x u sekundi. 
    ? duration 
    - ovo je obvio cemu sluzi
    ? lowerBound i upperBound
    - Sa ovim govorimo izmedju kojih vrednosti flutter animacija treba da se krece. Jer na kraju krajeva, svaka animacija se krece izmedju dve vrednosti. Inace lowerBound: 0 i upperBound: 1 su difoltne vrednost i samim tim ne moramo mi eksplicitno da ih setujemo, osim ofc, ako zelimo da promenimo te vrednosti */
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      // lowerBound: 0,
      // upperBound: 1,
    );

    /* ? pustamo animaciju, kao play 
      .forward(), .stop(), .repeat()
    */
    _animationController.forward();
  }

  /* ? dispose() - play the animation
  Da bismo mogli koristiti ovaj gore AnimationController, moramo da kreiramo dispose() metod koji sluzi sa playing the animacije. To je jos jedan metod ugradjen u flutter widgete koji se automatski pozove BTS, ali koji mozemo da overwritujemo i onda iza scene ponovo pozovemo parent widget metod sa super.dispose(), ali isto tako da ocistimo nas work.
  Recimo ovde sa _animationController.dispose(); cemo se uveriti da je AnimationController uklonjen iz memorije uredjaja onda kada je i ovaj widget uklonjen. Dakle ako uklonimo widget, onda cemo ukloniti i animaciju da preventivno sprecimo memory overflow. */
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /* Ovo je prvi x da koristimo method u StatelessWidgetu. Ugl to bude u StatefullWidgetu jer kad koristimo method ugl apdejtujemo neki state. Medjutim ovde necemo apdejtovati state vec cemo loadovati drugi screen.
  I za to cemo koristiti feature koji je build-inovan u Flutter: Navigator.
  Posto smo u StatelessWidgetu, context NIJE GLOBALNO dostupan, zato moramo da u _selectCategory prihvatimo argument BuildContext context */
  void _selectCategory(BuildContext context, Category category) {
    // final filteredMeals = dummyMeals
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    // Navigator.push(context, route); // nacin I
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          // onToggleFavorite: onToggleFavorite, //@ ukalnjamo jer kor. favorites_provider.dart
        ),
      ),
    ); // nacin II
  }

  @override
  Widget build(BuildContext context) {
    // u flutteru, kada kreiramo multi-screen app, da svaki screen koristi Scaffold widget jer je mozda AppBar drugaciji od screen-a do screen-a, drugaciji screen mzd ima drugaciji title ili btns u appbar

    /* kad smo uveli tabs.dart, imamo prikazano vise appBar title-ova, jer screens koje koristimo, svaki od njih ima appBAr title. Za categories.dart je lako, samo cemo tamo ukloniti Scaffold sa appBar i body (ostavljamo body content tj GridView tho) 
    
    ? AnimatedBuilder
    - animation u AnimatedBuilder-u je Listenable objekat, a nas _animationController je Listenable object   */
/* return  Scaffold(
    appBar: AppBar(title: const Text('Pick ur categories')),
    // body ja main page content
    body: GridView( */
    return AnimatedBuilder(
        animation: _animationController,
        child: GridView(
          padding: const EdgeInsets.all(24),
          // da kazemo koliko kolona treba da bude. crossAxisCount je s leva u desno, dakle horizontalno imam dve kolone. childAspectRatio sto se odnosi na velicinu grid itema
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2, // isto sto i 1.5 ???
            crossAxisSpacing: 20, // horizontalni razmak izmedju itema
            mainAxisSpacing: 20, // vertikalni razmak izmedju itema
          ),
          children: [
            // availableCategories.map((category) => CategoryGridItem(category: category)).toList()  je isto sto i ovo dole sa for-in
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              ),
          ],
        ),
        /* Padding ce biti widget koji ce biti animiran ciji ce child biti setovan na ovaj child od gore sto je GridView. gridView bi trebalo tehnicki da bude prikazan u Padding-u, ali nece se rebuild-ovati i reevaluated 60 x u sekundi (ako je animacija minut sa 60fps), vec ce se samo Padding rebuild-ovati.
        Animiracemo EdgeInsets.only gde cemo dinamicki setovati value za top. Da bismo pokrenuli animaciju moramo to explicitno da uradimo sa forward, tj _animationController.forward(); */
        builder: (context, child) => Padding(
            padding: EdgeInsets.only(
              top: 100 - _animationController.value * 100,
            ),
            child: child));
    // );
  }
}
