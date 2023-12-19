import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  vegeterian,
  vegan,
  lactoseFree,
  glutenFree,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegeterian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFilter) {
    state = chosenFilter;
  }

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // not allowed => Mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final filteredMeals = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (filteredMeals[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (filteredMeals[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (filteredMeals[Filter.vegeterian]! && !meal.isVegetarian) {
      return false;
    }
    if (filteredMeals[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
