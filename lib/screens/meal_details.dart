import 'package:flutter/material.dart';

import 'package:meal_app/models/meal.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    // required this.onToggleFavorite, //@ ukalnjamo jer kor. favorites_provider.dart
  });

  final Meal meal;
  // final void Function(Meal meal) onToggleFavorite; //@ ukalnjamo jer kor. favorites_provider.dart

  @override
  Widget build(BuildContext context) {
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
              onToggleFavorite(meal);
            },
            icon: const Icon(
              Icons.star,
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
