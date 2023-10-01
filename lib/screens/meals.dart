import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    // required this.title,
    this.title,
    required this.meals,
  });

  // ovde cemo imati i input jer ce mi trebati lista svih meals koji bi trebalo da se prikazu za zadatu kategoriju. Za to nam treba jos duymmy meal data, a za to cemo kreirati novi models meal.dart

  /* Za meals.dart je teze srediti duple titlove za appBar jer ne mozemo samo da ukonimo Scaffold jer se ono koristi i u categories.dart, a tamo nam je potreban Scaffold jer tamo nemamo bottom. ZAto cemo KONDICIONALNO koristiti taj Scaffold, i stavicemo da je title u meals.dart optiona sa String? i takodje mozemo da uklonimo required iz this.title gore jer title NE MORA da bude setovan.
  I sada idemo dole da konditionalno renderujemo title sa
   if (title == null) return bodyContent;
   i dole smo za title stavili ! */
  // final String title;
  final String? title;
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

    if (title == null) return bodyContent;

    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        // sa ListView.builde constructor-om kreiramo scrollable list view koji cini da samo items koji su vidljivi budu prikazani zbog boljih performansi
        body: bodyContent);
  }
}
