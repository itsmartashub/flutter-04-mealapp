import 'package:flutter/material.dart';
import 'package:meal_app/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals});

  // ovde cemo imati i input jer ce mi trebati lista svih meals koji bi trebalo da se prikazu za zadatu kategoriju. Za to nam treba jos duymmy meal data, a za to cemo kreirati novi models meal.dart

  final String title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
