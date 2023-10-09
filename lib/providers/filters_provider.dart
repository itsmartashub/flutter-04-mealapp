import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/providers/meals_provider.dart';

// premestamo iz filters.dart ovde
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  /* Ovde cemo za inicijalnu vrednost da stavimo Mapu filtera gde je svaki filter inicijalno setovan na false  */
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // ❌ nije dozvoljeno mutirati state !!!
    state = {...state, filter: isActive}; // ✅
  }

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

/* Inace mozemo ofc da dodamo vise providera u istom fajlu, razdvajamo ih samo zarad lakseg snalazenja. Ali ako se vise provajdera baziru jedan na drugi, ima smisla da ih strpamo u isti fajl */
final filteredMealsProvider = Provider((ref) {
  /* zxakhvaljujuci ovome ref.watch(mealsProvider), riverpod ce da apdejtuje ovo dole meals.where kad god se watched vrednost promeni, tako da vracamo apdejtovane podatke. I onda svaki widget koji bi osluskivao filteredMealsProvider ce takodje biti apdejtovan ako je neki od dependency tog provajdera apdejtovan */
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
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

    return true;
  }).toList();
});
