import 'package:flutter/material.dart';

import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // u flutteru, kada kreiramo multi-screen app, da svaki screen koristi Scaffold widget jer je mozda AppBar drugaciji od screen-a do screen-a, drugaciji screen mzd ima drugaciji title ili btns u appbar
    return Scaffold(
        appBar: AppBar(title: const Text('Pick ur categories')),
        // body ja main page content
        body: GridView(
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
              CategoryGridItem(category: category)
          ],
        ));
  }
}
