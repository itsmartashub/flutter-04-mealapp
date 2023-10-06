import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/data/dummy_data.dart';

/* iniciramo Provider i cuvamo ga u promenljivoj da bismo mobli da ga koristimo u app. Provider zahteva bar jedan position parametar: fn ProviderRef; ovo je fn koja ce automatski prihvatiti object jer ce ova f-ja, koju moramo da prosledimo u Provider, ce biti pozvana by flutter_riverpod package. Ova fn prihvata ref koji je tipa ProviderRef, i sad u ovoj fn vracamo vrednost koju zelimo da provajdujemo.
I sada mozemo ovo koristiti dummyMeals u bilo kom widgetu gde je ono neophodno */
final mealsProvider = Provider((ref) {
  return dummyMeals;
});
