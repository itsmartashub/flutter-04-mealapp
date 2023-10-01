import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals});

  // ovde cemo imati i input jer ce mi trebati lista svih meals koji bi trebalo da se prikazu za zadatu kategoriju. Za to nam treba jos duymmy meal data, a za to cemo kreirati novi models meal.dart

  final String title;
  final List<Meal> meals;

// vrlo bitn osto prihvata ne samo meal vec i context!!
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealDetailsScreen(
        meal: meal,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Widget bodyContent = ListView.builder(
    //   itemBuilder: (ctx, index) => Text(meals[index].title),
    // );
    Widget bodyContent = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Oh oh .. nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Try selecting a different category!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          )
        ],
      ),
    );

    if (meals.isNotEmpty) {
      bodyContent = ListView.builder(
        itemCount: meals.length,
        // itemBuilder: (ctx, index) => Text(meals[index].title),
        itemBuilder: (ctx, index) => MealItem(
            meal: meals[index],
            onSelectMeal: (meal) {
              selectMeal(context, meal);
            }),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // sa ListView.builde constructor-om kreiramo scrollable list view koji cini da samo items koji su vidljivi budu prikazani zbog boljih performansi
        body: bodyContent);
  }
}
