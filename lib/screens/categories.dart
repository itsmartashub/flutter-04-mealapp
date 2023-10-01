import 'package:flutter/material.dart';

import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/models/category.dart';
import 'package:meal_app/widgets/category_grid_item.dart';
import 'package:meal_app/screens/meals.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  /* Ovo je prvi x da koristimo method u StatelessWidgetu. Ugl to bude u StatefullWidgetu jer kad koristimo method ugl apdejtujemo neki state. Medjutim ovde necemo apdejtovati state vec cemo loadovati drugi screen.
  I za to cemo koristiti feature koji je build-inovan u Flutter: Navigator.
  Posto smo u StatelessWidgetu, context NIJE GLOBALNO dostupan, zato moramo da u _selectCategory prihvatimo argument BuildContext context */
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    // Navigator.push(context, route); // nacin I
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    ); // nacin II
  }

  @override
  Widget build(BuildContext context) {
    // u flutteru, kada kreiramo multi-screen app, da svaki screen koristi Scaffold widget jer je mozda AppBar drugaciji od screen-a do screen-a, drugaciji screen mzd ima drugaciji title ili btns u appbar

    /* kad smo uveli tabs.dart, imamo prikazano vise appBar title-ova, jer screens koje koristimo, svaki od njih ima appBAr title. Za categories.dart je lako, samo cemo tamo ukloniti Scaffold sa appBar i body (ostavljamo body content tj GridView tho) */
/* return  Scaffold(
    appBar: AppBar(title: const Text('Pick ur categories')),
    // body ja main page content
    body: GridView( */
    return GridView(
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
    );
    // );
  }
}
