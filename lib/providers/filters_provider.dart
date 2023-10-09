import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());
