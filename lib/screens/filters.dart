import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:meal_app/screens/tabs.dart';
// import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/providers/filters_provider.dart';

/* 
// Premesteno u filters_provider.dart
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
} */

// class FiltersScreen extends StatefulWidget {
class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  // da se ne bi resetovali filteri kada idemo na FiltrersScreen
  final Map<Filter, bool> currentFilters;

  @override
  ConsumerState<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;

  /* ! da se ne bi resetovali filteri kada idemo na FiltersScreen, i dodajemo im inicijalnu vrednost widget.currentFilters[...]!;
  widget je specijalan property da mozemo da pristupimo propertijima i metodama ove widget klase. Samo widget property nije dostupan ovde gore gde inicijalizujemo promenljive ove klase, recimo:
      var _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree]!; ❌ 
  vec je samo dostupno unutar metoda ove klase. Zato cemo ovde gore ostaviti da inicijalno sve vrednost budu false, ali cemo u initState() gde cemo nakon zvanja super.initState() da overwrittujemo ove vrednosti, sa vrednostima koje smo dobili preko widget-a, tj sa currentFilters */
  @override
  void initState() {
    super.initState();
    _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree]!;
    _lactoseFreeFilterSet = widget.currentFilters[Filter.lactoseFree]!;
    _vegetarianFilterSet = widget.currentFilters[Filter.vegetarian]!;
    _veganFilterSet = widget.currentFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
        // pravimo Column jer zelimo da prikazemo multiple filter sviceve za filter on-off
      ),
      /*  // s ovim ce back button na ovom FiltersScreen-u da nestane, i bice zamenjen sa drawer button gde kad kliknemo pojavi se side drawer
      drawer: MainDrawer(onSelectScreen: (identifier) {
        Navigator.of(context).pop();

        if (identifier == 'meals') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => const TabsScreen(),
          ));
        }
      }), */
      /* ? WillPopScope
      Zelimo da znamo kada je korisnik kliknuo back, bilo sistemsko dugme ili u sklopu app
      WillPopScope ima onWillPop parametar koji je fn koja vraca FUTURE (Futures su objekti koji resavaju nase vrednosti, tj vrednosti koji jos uvek ne postoje). I ta fn ce Flutter invokovati svaki x kada korisnik pokusa da napusti ovaj Screen.
      * Ovde nam .pop() omogucava to da prosledimo neke podatke koji ce biti dostupni u tom Screenu kom navigiramo (FiltersScreen), a to mesto je TabsScreen. NE RAZUMEM
      U ovom .pop mozemo proslediti bilo koju vrstu podataka. Mi cemo vratiti Map koji ce imati razlicite keys za razlicite filtere, i true ili false u zavisnosti od toga d ali je taj filter setovan ili ne.
      Da bismo standardizovali te keys, dodacemo gore on the top enum Filter */
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({
            Filter.glutenFree: _glutenFreeFilterSet,
            Filter.lactoseFree: _lactoseFreeFilterSet,
            Filter.vegetarian: _vegetarianFilterSet,
            Filter.vegan: _veganFilterSet,
          });

          // __Future
          /*  moramo vratiti true ili  false u zavisnosti da li zelimo da nnavigujemo back ili ne. Ali posto rucno navigujemo nazad ovde gore sa Navigator.of(context).pop({...}), moramo da vratimo false, da ne bismo poppovali 2x, jer bismo verov ugasili app.
          DA nismo iznad pop-ovali, vec radili nesto drugo, tipa suvali podatke u neku db, onda bismo ovde morali vratiti true ako zelimo da omogucimo korisniku da napusti Screen.
          
          ! Inace, posto onWillPop zeli da vratimo FUTURE, pa zato dodajemo ispred ove anonim fn rec async, jer pomocu toga ne samo da mozemo da kor await keyword, vec i da wrapujemo vrednost koju vracamo (return false) u future
          
          kada idemo u tabs.dart u fn _setScreen i hoverujemo misem na ono "push" u Navigatoru, VSC nam kaze da se vraca Future */
          return false;
        },
        child: Column(
          children: [
            /*
          ? SwitchListTile - radio btn u CSS
          value je boolean: true (on) ili false (off)
          onChanged je fn koja prihvata boolean, i ona ce se trigerovati kada god se switch pritisne
          title je nesto poput labela */
            SwitchListTile(
              value: _glutenFreeFilterSet,
              onChanged: (isChecked) {
                // posto apdejtujemo UI kor setState
                setState(() {
                  _glutenFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'Gluten-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                'Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _lactoseFreeFilterSet,
              onChanged: (isChecked) {
                // posto apdejtujemo UI kor setState
                setState(() {
                  _lactoseFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'Lactose-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                'Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _vegetarianFilterSet,
              onChanged: (isChecked) {
                // posto apdejtujemo UI kor setState
                setState(() {
                  _vegetarianFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                'Only include vegetarian meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isChecked) {
                // posto apdejtujemo UI kor setState
                setState(() {
                  _veganFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                'Only include vegan meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
