import 'package:flutter/material.dart';

import 'package:meal_app/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    // Zelimo da items (child) budu tapables. Ali to mozemo i sa GestureDetector. Medjutim sa InkWell dobijemo isto sto i sa GestureDetector al ovde imamo i nice visually prikaz da se tapnulo
    return InkWell(
      onTap: () => {},
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      // koristimo Container widget jer nam on daje dosta opcija za bg color i bg decoration in general za ovaj widget
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
