import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/favorites_provider.dart';

//@ BEZ flutter_riverpod
// class MealDetailsScreen extends StatelessWidget {

//@ SA flutter_riverpod
class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    // required this.onToggleFavorite, //@ ukalnjamo jer kor. favorites_provider.dart
  });

  final Meal meal;
  // final void Function(Meal meal) onToggleFavorite; //@ ukalnjamo jer kor. favorites_provider.dart

  @override
  //@ BEZ flutter_riverpod
  // Widget build(BuildContext context) {

/* @ SA flutter_riverpod 
! Dodajemo  drugi parametar WidgetRef ref, dakle type WidgetRef koji nam je potreban za osluskivanje provajdera. Ovo nismo morali da radimo u tabs.dart jer tamo imamo State klasu i zamenjujemo je sa ConsumerState koji cini ovaj ref property dostupnim globalno u toj klasi, a ovde u StatelessWidgetu je drugacije. Ovde nemamo ovaj geenralni ref property, vec ga moramo dodati ovde kao parametar build metodu */
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

    // Scaffold jer je brand new screen
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        /* @favorites
        favorite button koje ce da bude toggle fazon, dakle ili ce da dodaje u fav listu ili ako je item vec u fav listi, onda ce da ga brise. Dakle negde u apliakciji moramo kreirati state ovoga; moramo da upravljamo listom meal itema tj meal ID-evima, ali sad je pravo pitanje gde cemo da menadzujemo ovaj state? 
        Ovde u meal_details.dart necemo sig jer necemo moci da joj pristupamo iz drugih widgeta, a recimo favorites bi nam bili potrebni u tabs.dart jer tu prikazujemo MealsScreen u kom cemo proslediti listu omiljenih meal-ova
        Dakle u TabsScreen se koristi, ali manipulisemo listom (add/remove) odavde iz MealDetailsScreen, zato cemo morati da kreiramo fn koja dodaje i uklanja favorites u TabsScreen state, ali cemo morati proslediti ovu f-ju dalje (down) u MealsDetailsScreen pa tako da kad tapnemo na Favorite button, zapravo promenimo state u TabsScreen-u.
        Dakle idemo u tabs.dart u _TabsScreenState da kreiramo List-u mealova  */
        //
        actions: [
          IconButton(
            onPressed: () {
              // onToggleFavorite(meal); //@ ukalnjamo jer kor. favorites_provider.dart
              // ovo .notifier nam daje pristup FavoriteMealsNotifier-u koji imaovaj metod koji zelimo da pozovemo (toggleMealFavoriteStatus)
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(meal);

              // prvo cistimo sve snackbar ukoliko je neki ostao
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(wasAdded
                      ? 'Meal added as a favorites.'
                      : 'Meal removed.'),
                ),
              );
            },
            // zalimo da animiramo samo ikonicu, dakle ne citvo dugme
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // ne trba da kreiramo animaciju rucno ovdem vec je ovo animation kreirano od strane Fluttera, zato se ovo zove implicitna animacija; AnimatedSwitcher ce to sve za nas da uradi behind-the-sceen: kreirace animaciju i startovati je, a startovace je kad god se child promeni, automatski ce to detektovati i pokrenuti animaciju. transitionBuilder mora da vrati widget, ali ne bilo koji vec neki od transition widgeta, jer ono opisuje KAKO zelimo da animiramo. child je widhet koji ce prihvatiti ovuu rotacionu animaciju, a to je na kraju ovaj child: Icon(isFavorite ? Icons.star : Icons.star_border)
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  // turns: animation,
                  // turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                  turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                );
              },
              /* ? trigerovanje animacije
              moramo dodati key u Icon koji ce pomoci da shvatimo da li imamo drugaciji widget nego ranije iako je mozda type isti. a ValueKey isFavorite ce biti ili true ili false i onda ce flutter videti da se NESTO promenilo ovde i to ce triggerovati animaciju */
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavorite),
              ),
            ),
          )
        ],
      ),

      /* ? SingleChildScrollView or ListView
      Da bi child bio scrollable zamenjujemo Column sa SingleChildScrollView ili ListView. Ali ne ListView.builder jer ovde necemo imati predugacku listu itema, vec samo ListView.
      I sad jeste scrollable, ali su childovi poremeceni sad haha, vise nicu u centru kao kada su u Column widgetu. 
      Zato cemo ipak vratiti Column i njega wrapovati u SingleChildScrollView widget */
      // body: ListView(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),

            // uzvicnik je da kazemo dartu da ce to postojati
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(height: 24),

            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
