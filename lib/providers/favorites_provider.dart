import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/models/meal.dart';

/* ? StateNotifierProvider i StateNotifier
- Ovaj x necemo kreirati instancu projvajdera sa Provider(), to je ok kada imamo staticke podatke, tj listu koje se nikad ne memja. Ako imamo kompleksnije podatke koji bi trebalo da se izmene zbog raznih okolnosti, nije dobro koristiti Provider() klasu, vec StateNotifierProvider() klasu.
- Ova StateNotifierProvider klasa radi zajedno sa jos jednom klasom: StateNotifier, kao recimo i StatefulWidget sto radi zajedno sa State objektima.
- StateNotifier se ne instancira StateNotifier() vec se koristi kao klasa koju extendujemo na klasu koji nazovemo nesto pa Notifier */

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  /* * 1. initial value recimo empty list.
- Dodajemo super() da  bismo reachovali parent klasu, i u super prosledjujemo nase inicijalne podatke. Oni mogu biti u kom god obliku (list, map, string, another object based on another class..), ali treba biti tip podataka koji smo naveli u angular brackets: <List<Meal>> u nasem slucaju */
  FavoriteMealsNotifier() : super([]);

  /* * 2. all the methods that should exists to change that value,  to change that list in this case
  - toggleMealFavoriteStatus treba da dobije type Meal kao input, i Nikad ne sme da ovde doda ta vrednost i onda teba da doda taj meal u tu listu ako jos uvek nije favorit, i ukloniti je ukoliko vec jeste u favorites listi. Deluje kao da mozemo koristi logiku koju smo vec koristili u tabs.dart u _toggleMealFavoriteStatus(Meal meal) gde koristimo taj meal, proveravamo da li vec postoji u listi, ako da, uklanjamo ga, ako ne, dodajemo ga.
  - Medjutim, TO OVDE NE BI F-NISALO! Jer ono sto je bas bitno da upamtimo kada je u pitanju vrednost kojom rukovodimo ovim Notifier-om, jeste da:
  ! NIKAD NE SMEEMO DA EDITUJEMO TU VREDNOST
  * Rekli smo vec ranije da kada kreiramo objekte, ti objekti bivaju sacuvani u memoriji uredjaja, i mogu biti zamenjeni novim objektima koji imaju novu adresu u memoriji, i u tom slucaju ako se stara vrednost vise nigde ne koristi, ona ce biti izbrisana. Ali isto tako mozemo editovani vec psotojeci objekat u memoriji tako da adresa ostaje ista, i manipulisemo podatkom koji vec postoji u memoriji umesto da ga zamenimo dodavajuci novi, A TO U StateNotifier NIJE DOZVOLJENO!!!!
  __ NIJE NAM DOZVBOLJENO DA EDITUJEMO VREDNOST KOJA VEC POSTOJI U MEMORIJI VEC UVEK MORAMO DA KREIRAMO NOVU!!! */
  void toggleMealFavoriteStatus(Meal meal) {
    // state.add(); // ❌
    // state.remove(); // ❌
    final mealIsFavorite = state.contains(meal); // ✅

    if (mealIsFavorite) {
      // ✅ where moze jer ono KREIRA/VRACA NOVU LISTU, ne edituje postojecu!
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      // ✅ kreiranje nove (meal) dodavajuci stare elemente (...state)
      state = [...state, meal];
    }
  }
}

/* Ovaj provajder vraca instancu nase notifier klase tako da imamo ovu klasu za editovanje stejta i za retrieving stejta.
- StateNotifierProvider je genericki tip (angular brackets), on razume da treba da vraca FavoriteMealsNotifier ali ne razume koje podaktke ovaj notifieer vraca. Ovde imamo 2 genericka tipa: jedan je FavoriteMealsNotifier, a drugi su podaci koje su yielded by FavoriteMealsNotifier, a to ce biti lista meals-a
```    <FavoriteMealsNotifier, List<Meal>>  */
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
